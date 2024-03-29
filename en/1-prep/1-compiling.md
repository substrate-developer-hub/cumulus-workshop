# Compilation

This workshop covers the entire process of launching a relay chain, connecting parachains,
transferring assets between chains, and developing your own parachain runtimes. Naturally, there
will be some significant compiling if you intend to build everything yourself.

Compiling the Polkadot and parachain template nodes can be avoided if you prefer to use the
Docker images.

## Setup Local Development Environment

Follow the instructions here to [setup a local development environment](https://substrate.dev/docs/en/knowledgebase/getting-started/)
for Substrate.

> NOTE: If you are already setup with a local development environment, remember to ensure that you are building with the latest stable toolchain: use `rustup update` before moving forward!

## Building the Polkadot Relay Chain Node

Clone the Polkadot repository, and build the node. We are using a
[specific git tag](/#versions-of-software) for this workshop. Perform these steps in your typical
workspace directory.

```bash
# Clone the Polkadot Repository
git clone https://github.com/paritytech/polkadot.git

# Switch into the Polkadot directory
cd polkadot

# Checkout the proper commit
git checkout release-v0.9.10

# Build the relay chain Node
cargo build --release

# Check if the help page prints to ensure the node is built correctly
./target/release/polkadot --help
```

If the help page is printed, you have succeeded in building a Polkadot node.

For the rest of this workshop, we will refer to this binary simply as `polkadot`.

## Building the Parachain Template

We will use the [**Parachain Template**](https://github.com/substrate-developer-hub/substrate-parachain-template)
(similar to the [Node Template](https://github.com/substrate-developer-hub/substrate-node-template))
to launch our first parachain and make cross-chain asset transfers. Later, we will
use it as the starting point for developing our own parachains. Perform these steps in your typical
workspace directory.

```bash
# Clone the Parachain Template
git clone https://github.com/substrate-developer-hub/substrate-parachain-template

# Switch into the Parachain Template directory
cd substrate-parachain-template

# Checkout the proper commit
git checkout polkadot-v0.9.10

# Build the parachain template collator
cargo build --release

# Check if the help page prints to ensure the node is built correctly
./target/release/parachain-collator --help
```

If the help page is printed, you have succeeded in building a Cumulus-based parachain collator.

For the rest of this workshop we will refer to it simply as `parachain-collator`.
