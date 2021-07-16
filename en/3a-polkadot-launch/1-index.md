toc:
- intro, overview
- using polkadot-launch

- launching polkadot, and parachain template tgt
  - the config setup

- explaining the config you can do
  - `relaychain`
  - `parachains`
  - `simpleParachains`
  - `hrmpChannels`
  - `types`
  - `finalization`

- brief desc of how it's work

---
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
    - `nodes`: number of nodes we have, and as mentioned 3 nodes with the respective well known address as the session keys, its respective socket port and port listening to.

  Inside `parachains` key, we see two parachain are defined, with
    - `bin`: where the binary is located
    - `id`: the Para ID of each chain
    - `balance`: Initial balance to be set for key-known account
    - `nodes`: the nodes setting for the corresponding parachains. We see that each parachain has one node setup.

  We will go through the rest of the options later.

3. Let's update the `bin` location for the relaychain and parachains. Both parachains will use the same Parachain Template binary.
