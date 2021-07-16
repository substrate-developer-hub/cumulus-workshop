# Launching Relay Chain & Parachains with `polkadot-launch`

## Overview

Now that we have gone through the procedure of manually launching a relay chain of a few nodes, and a parachain. You might wonder this is all quite a hassle if you have to go through this exercise each time when developing and testing for parachain development.

Fortunately, there is actually a Node utility script, [`polkadot-launch`](https://github.com/paritytech/polkadot-launch) that automate the above process. But it will still be good to know what's involved under the hood, and when things go wrong, you know how it should be done, and troubleshoot the issue.

Now, let's install the utility script and try it out.

## Installation

Run the following command to install the script globally in your environment

```bash
yarn global add polkadot-launch
```

To verify it is installed properly, run the command below should return its current version.

```bash
polkadot-launch --version
# 1.6.2
```

## Kickstart

In this exercise, we will launch a **Polkadot relay chain of three nodes, and then two parachains, each with one node only**.

1. We first get our Polkadot and Parachain Template cloned, and compiled. Goto [this section](/en/1-prep/1-compiling?id=building-the-polkadot-relay-chain-node) for instruction on getting Polkadot compiled, and [here](/en/1-prep/1-compiling?id=building-the-parachain-template) for Parachain Template compiled.

2. `polkadot-launch` reads a config file to know all the config required to launch its relaychain and parachain and all the necessary startup config. We have that setup already and can be seen [here](/shared/polkadot-launch-config/relay-3-2para-1.json).

  Let take a brief look at the file. Inside the `relaychain` key, we see
    - `bin`: specifying where the binary is
    - `chain`: the type of the relay chain we are launching
    - `nodes`: number of nodes we have, and as mentioned 3 nodes with the respective well known address as the session keys, its respective websocket port (`wsPort`) and TCP port (`port`) listening to.

  Inside `parachains` key, we see two parachain are defined, with
    - `bin`: where the binary is located
    - `id`: the Para ID of each chain
    - `balance`: Initial balance to be set for key-known account
    - `nodes`: the nodes setting for the corresponding parachains. We see that each parachain has one node setup.

  We will go through the rest of the options later.

3. Let's update the `bin` location for the relaychain and parachains to an absolute path where your binaries are located. For the two parachains, use the same Parachain Template binary.

  Now you could run with:

  ```bash
  polkadot-launch relay-3-2para-1.json
  ```

  If everything go well, you should see messages similar to the following

  ```bash
  <tk>
  ```

4. Now if you open up another console and inspect the current directory, you will see the relay chain node log are written to `alice.log`, `bob.log`, and `charlie.log`. While the parachain log is indicated with the websocket port numbers they are listening to, so you should see `9988.log`and `9999.log` there.

Congratulation! You have automated the launch of a 3-node relay chain, and two parachains with a single node using `polkadot-launch` CLI utility.

Next, we will go through the configuration parameters that `polkadot-launch` recognizes in the config file.

## `polkadot-launch` Configuration

The config files can broadly divided into five sections, shown below.

```json
{
  "relaychain": {
    //...
  },
  "parachains": [{
    //...
  }, {
    //...
  }],
  "simpleParachains": [{
    //...
  }, {
    //...
  }],
  "hrmpChannels": [{
    //...
  }],
  "types": {},
  "finalization": false
}
```

### `relaychain` Section

As briefly mentioned above, this section of json specify how the relaychain should be launched. The full config look like the following:

```json
"relaychain": {
  "bin": "./bin/polkadot",
  "chain": "rococo-local",
  "nodes": [
    {
      "name": "alice",
      "wsPort": 9944,
      "port": 30444,
      "basePath": "/tmp/alice",
      "flags": ""
    },
    {
      //...
    }
  ],
  "genesis": {
    "runtime": {
      "runtime_genesis_config": {
        "parachainsConfiguration": {
          "config": {
            "validation_upgrade_frequency": 1,
            "validation_upgrade_delay": 1
          }
        }
      }
    }
  }
}
```

We have gone through the `bin`, `chain`, and `nodes` [above](#kickstart).

For each node inside `nodes`, you could have the following keys:

- `name`: Must be one of alice, bob, charlie, or dave.
- `wsPort`: The websocket port for this node.
- `port`: The TCP port of this node.
- `basePath`: Where the chain storage is stored at. If not specified, the chain is run with `--tmp` flag.
- `flags`: Any addition flags that would be passed to the relay chain.

Finally, there is `genesis`. It is a JSON object of the properties you want to modify from the genesis configuration. Non-specified properties will be unchanged from the original genesis configuration. Regarding the `genesis` value, it is the same as all the values shown in the chainspec shown by using the following commands:

```bash
./polkadot build-spec --chain=rococo-local --disable-default-bootnode
```

### `parachains` Section

`parachains` is an array of objects that look like the following:

```json
"parachains": [
  {
    "bin": "./bin/polkadot-collator",
    "id": "200",
    "balance": "1000000000000000000000",
    "nodes": [
      {
        "wsPort": 9988,
        "port": 31200,
        "name": "alice",
        "flags": ["--", "--execution=wasm"]
      }
    ]
  },
  {
    // ...
  }
]
```

- `bin`: The path of the collator node binary. Use an absolute path here.
- `id`: The Para ID to assign to this parachain. Must be unique.
- `balance`: (Optional) Configure a starting amount of balance on the relay chain for this chain's account ID.
- For each node in `nodes`, it has the same configuration as node config in the relay chain.

In this way, we can specify the parachain, and nodes used to run the parachain collator.

### `simpleParachains` Section

`simpleParachains` section is similar to `parachains` section:

```json
"simpleParachains": [
  {
    "bin": "./bin/adder-collator",
    "id": "400",
    "port": "31400",
    "name": "alice",
    "balance": "1000000000000000000000"
  }
]
```

This is similar to parachains but for "simple" collators like the adder-collator, a very simple collator that lives in the polkadot repo and is meant for simple testing. It supports a subset of configuration values, and is meant to run with a single node only:

- `bin`: The path to the collator binary.
- `id`: The id to assign to this parachain. Must be unique.
- `port`: The TCP port for this node.
- `balance`: (Optional) Configure a starting amount of balance on the relay chain for this chain's account ID.

### `hrmpChannels` Section

`hrmpChannels` looks similar to the following:

```json
"hrmpChannels": [
  {
    "sender": 200,
    "recipient": 300,
    "maxCapacity": 8,
    "maxMessageSize": 512
  }
]
```

This specifies HRMP channels to be open between the specified parachains so that it's possible to send messages between those. Keep in mind that an HRMP channel is unidirectional and in case you need to communicate both ways you need to open channels in both directions.

### Remaining

Finally, we have `types`, and `finalization`.

- `types`: The custom Polkadot-JS custom types to be fed to Polkadot-JS API.
- `finalization`: either `true` or `false`, whether you want transaction submitted from `polkadot-launch` wait for block finalization.

## Conclusion

In this chapter, you have learned about `polkadot-launch` node utility script, and are able to launch relay chain and parachains all in just a single command line.

This is a good basis to get to our next subject, actual parachain development.
