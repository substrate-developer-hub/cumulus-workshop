# Launch development environment with `polkadot-launch`

## Overview

Now that we have gone through the procedure of manually launching a relay chain of a few nodes, and
a parachain, you can automate testnets for development and testing.
[`polkadot-launch`](https://github.com/paritytech/polkadot-launch) is a Node utility script that
does this for you, allowing for some custom configurations to setup networks very simply.

Note that this isn't a replacement for the manual proccess, as this script is not a perfect fit for
all use cases and may fail for yours, so when things go wrong, you know the [manual
steps](en/1-prep/1-compiling) that this script is executing for you to troubleshoot.

Now, let's install the utility script and try it out.

## Installation

### Global Install (Option A)

For most cases, you do not need to edit `polkadot-launch`. Run the following command to install the
script globally in your environment:

```bash
yarn global add polkadot-launch
# Check install:
polkadot-launch --version
# 1.7.0
```

### Clone & Local Build (Option B)

If you find you need to edit the script, or otherwise would like to build this yourself, do:

```bash
git clone git@github.com:paritytech/polkadot-launch.git
cd polkadot-launch
# You need node v14+ -- https://www.geeksforgeeks.org/how-to-update-node-js-and-npm-to-next-version/
yarn install
# The entry point is `cl.js`
node dist/cli.js --version
# 1.7.0
```

If you think your edits are valuable, please consider [opening a PR](https://github.com/paritytech/polkadot-launch).

## Basic Configuration

In this exercise, we will launch a **Polkadot relay chain of three nodes and two parachains, each with one node only**.

### Prerequisites

1. We first get our Polkadot and Parachain Template cloned, and compiled.

   1. Build Polkadot, instructions [here](/en/1-prep/1-compiling?id=building-the-polkadot-relay-chain-node)
   2. Build a Parachain, instructions [here](/en/1-prep/1-compiling?id=building-the-parachain-template)

2. Write a config file for `polkadot-launch` to fit your needs.
   - **Here is a template we will modify to get started:**
     <a target="_blank"
     href="shared/polkadot-launch-config/relay-3-validators--2paras-1collator.json">relay-3-validators--2paras-1collator.json</a>

<!-- for some reason this links can't be markdown. See https://github.com/substrate-developer-hub/cumulus-workshop/issues/16 -->

Let take a brief look at the file. Inside the `relaychain` key, we see:

- `bin`: specifying where the relay chain binary is
- `chain`: the type of the relay chain we are launching
- `nodes`: number of nodes we have

As mentioned 3 nodes with the respective well known address as the session keys, its
respective websocket port (`wsPort`) and TCP port (`port`) listening to.

Inside `parachains` key, we see **two parachains** are defined, each with:

- `bin`: where the parachain binary is located
- `id`: the Para ID of each chain
- `balance`: Initial balance to be set for key-known account
- `nodes`: the nodes setting for the corresponding parachains

We see that each parachain has one node setup.

3. **Update the `bin` location for the relaychain and parachains to an absolute path where your**
   **binaries are located. For the two parachains, use the same Parachain Template binary.**

### Launch a Network

Now you can start your network with the commands:

```bash
mkdir <some empty working directory for log files and new chainspecs>
cd <your logfile & chainspec dir>
# Move the example relay-3-validators--2paras-1collator.json file in this dir
#
# If installed globally:
polkadot-launch relay-3-validators--2paras-1collator.json
# If installed locally
node ./<path to polkadot-launch>/dist/cli.js relay-3-validators--2paras-1collator.json
```

If everything go well, you should see messages similar to the following:

![polkadot-launch-log.png](../../assets/img/polkadot-launch-log.png)

Now open your working directory to find the relay chain node log are written to `alice.log`,
`bob.log`, and `charlie.log` for your three validators, respectively. While the parachain log is
indicated with the websocket port numbers they are listening to, so you should see `9988.log`and
`9999.log` there for each unique instance of your parachains. There are also the customized chain
spec files used to launch each network, including the change of `paraID` used for each instance of
the parachain used in your file.

If you wish to monitor the logs in real time, you can do so with:

```bash
# While `polkadot-launch` is running...
# Open a new terminal for each node and monitor logs with:
tail -f <logfile>
```

Another way to verify the setup is correct, is by going to [Polkadot-JS Apps **Network** -
**Parachains** tab](https://polkadot.js.org/apps/#/parachains), after configure to connect to a
**relay chain node**, you should see the UI showing two parachains being connected to the relay chain.

![polkadot-apps-with-2-parachains](../../assets/img/polkadot-apps-with-2-parachains.png)

Congratulation! You have automated the launch of a 3-node relay chain, and two parachains with a
single node using `polkadot-launch` CLI utility.

Next, we will go through in details the configuration parameters that `polkadot-launch` recognizes in the config file.

## `polkadot-launch` Configuration

The config file can broadly divided into five sections, shown below.

```json
{
  "relaychain": {
    //...
  },
  "parachains": [
    {
      //...
    },
    {
      //...
    }
  ],
  "simpleParachains": [
    {
      //...
    },
    {
      //...
    }
  ],
  "hrmpChannels": [
    {
      //...
    }
  ],
  "types": {},
  "finalization": false
}
```

### `relaychain` Section

This section of JSON specifies how the relaychain should be launched. The full config looks like the following:

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

- `name`: Must be one of `alice`, `bob`, `charlie`, or `dave`.
- `wsPort`: The websocket port for this node.
- `port`: The TCP port of this node.
- `basePath`: Where the chain database are going to be saved.If unspecified, the chain is run with `--tmp` flag.
- `flags`: Any addition flags that would be passed to the relay chain.

Finally, there is `genesis`. It is a JSON object of the properties you want to modify from the genesis configuration. Non-specified properties will be unchanged from the original genesis configuration. Regarding the `genesis` value, it is the same as all the values shown in the chainspec when generated by the following commands:

```bash
./polkadot build-spec --chain=rococo-local --disable-default-bootnode
```

### `parachains` Section

`parachains` is an array of objects, configuring how one or more parachains are to be launched. It looks like the following:

```json
"parachains": [
  {
    "bin": "./bin/parachain-collator",
    "id": "2000",
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
- `id`: The Para ID assigned to this parachain. Must be unique.
- `balance`: (Optional) Configure a starting amount of balance on the relay chain for this chain's account ID.
- For each node in `nodes`, it has the same configuration as node config in the relay chain.

### `simpleParachains` Section

This is similar to parachains but for "simple" collators like the [adder-collator](https://github.com/paritytech/polkadot/tree/master/parachain/test-parachains/adder/collator), a very simple collator that lives in the polkadot repo and is meant for simple testing. It supports a subset of configuration values, and is meant to run with a single node only:

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

- `bin`: The path to the collator binary.
- `id`: The id to assign to this parachain. Must be unique.
- `port`: The TCP port for this node.
- `balance`: (Optional) Configure a starting amount of balance on the relay chain for this chain's account ID.

### `hrmpChannels` Section

This section specifies HRMP channels to be open between the specified parachains so that it's possible to send messages between those. Keep in mind that an HRMP channel is unidirectional and in case you need to communicate both ways you need to open channels in both directions.

`hrmpChannels` looks similar to the following:

```json
"hrmpChannels": [
  {
    "sender": 2000,
    "recipient": 3000,
    "maxCapacity": 8,
    "maxMessageSize": 512
  }
]
```

### Remaining

Finally, we have `types`, and `finalization`.

- `types`: The custom Polkadot-JS custom types to be fed to Polkadot-JS API.
- `finalization`: either `true` or `false`, whether you want transaction submitted from `polkadot-launch` to wait for block finalization.

## How It Works

This tool just automates the steps you learned previously to spin up multiple relay chain nodes and parachain nodes in order to create a local test network. It also leverage on Polkadot-JS API to connect to these spawned nodes over their WebSocket endpoints.

## Conclusion

In this chapter we have covered about `polkadot-launch` Node utility. You are now able to build up your own config file, and launch a relay chain and parachains set all in just a single command.

This is a good basis to get to our next subject, actual parachain development.
