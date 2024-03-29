# Substrate Cumulus Workshop

In this hands-on workshop, participants will start a Polkadot-like chain (the relay chain), register
parachains, make cross-chain asset transfers, and convert their own Substrate runtimes to parachains
using Cumulus.

## Substrate Experience

If you are here _without_ any former Substrate experience, you are likely to not understand or
complete this tutorial. Before you continue please complete the following tutorials:

- [Create Your First Substrate Chain](https://substrate.dev/docs/en/tutorials/create-your-first-substrate-chain/)
- [Start a Private Network](https://substrate.dev/docs/en/tutorials/start-a-private-network/)

We will reference these assuming you have already understand all the steps involved, and
have your machine configured to compile Substrate-based projects.

## Hardware Requirements

In this workshop, we will be using [Substrate Parachain Template](https://github.com/substrate-developer-hub/substrate-parachain-template). Compiling this project is a resource intensive
process! We suggest compiling and running Parachain template on a machine with **no less than**:

- 8 GB of RAM (16 is suggested)
- 4 CPU cores (8 is suggested)
- 50 GB of free HDD/SSD space

Without the minimal RAM here, you are likely to _run out of memory resulting in a `SIGKILL`
error_. This generally happens on the `polkadot-service` build - so be sure to _monitor your RAM
usage_ (with something like [`htop`](https://htop.dev/)) and look out as swap memory starting to be
used.

If you cannot find a machine with the minimums here, try the following that trade longer build
time for more limited memory usage.

- Use less threads: cargo's `-j` flag specifies the number of threads to use to build. Try to use one less than the CPU cores your machine has.
- Cargo's [codegen units](https://doc.rust-lang.org/cargo/reference/profiles.html#codegen-units)
  feature makes more optimized builds, with less ram, but _much_ longer compile times.

```bash
# use less codegen units
RUSTFLAGS="-C codegen-units=1" cargo build --release
# set the number of cores/threads to compile (used to build cumulus/polkadot on rpi 3)
cargo build --release -j 1
```

## Software Version

At the moment, parachains are _very tightly coupled_ with the relay chain's codebase they are
connecting to. If you want to connect your parachian to a running relay network like the
[Rococo](https://wiki.polkadot.network/docs/en/build-parachains-rococo) test network, you _must_ be
sure that you are testing against the exact same build of that relay chain.

This workshop has been tested on commits:

- **Polkadot** tagged [**`release-v0.9.10`**](https://github.com/paritytech/polkadot/tree/v0.9.9)
- **Parachain Template** tagged [**`polkadot-v0.9.10`**](https://github.com/substrate-developer-hub/substrate-parachain-template/tree/polkadot-v0.9.10)
- **Polkadot-JS Apps** tagged [**`v0.96.2-34`**](https://github.com/polkadot-js/apps/commit/1073f1b79bf0aec1c853441e3bbac614defce76e).
  It is generally expected that the [hosted Polkadot-JS Apps](https://polkadot.js.org/apps/#/explorer) should work. If you have issues, build and run this UI yourself, at this tagged version.

> NOTE: you **must** use these version exactly to ensure that you do not run into conflicts as
> parachain development is actively making breaking changes between commits on these
> repositories!

#### Polkadot Testnet Compatibility

We are doing our best to keep the parachain template & this workshop updated presently
with the latest release of Polkadot. Please check with us in the [Parachain Technical matrix channel](https://matrix.to/#/#parachain-technical:matrix.parity.io)
when breaking changes and testnet resets occur.

## Learn More

Read about [The Path of a Parachain Block](https://polkadot.network/the-path-of-a-parachain-block/)
on the official Polkadot Blog.

## Acknowledgement & Contribution

Refer to [Acknowledgement & Contribution](acknowledgement-contribution.md)

## License

[MIT](LICENCE)

## Disclaimer

**Cumulus is pre-release software that is still under development.** While this workshop strives to
be useful, the material it covers may change or break before Cumulus is fully released. Nothing
presented here is ready for use in value-bearing blockchains!
