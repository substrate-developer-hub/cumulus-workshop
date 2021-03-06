<!-- fIXME - docker for this is presently not maintained. this was simply copied from the compilation page. Needs to be updated to be used! -->

## Shortening the Workshop

If you intend to use this material for a live workshop you may shorten it by cutting steps off of
the end. If your workshop will not cover writing your own parachains, you may skip all the
compilation by using the provided docker images.

If you prefer to focus primarily on development in your workshop, you may also skip initial relay
chain setup by performing those steps yourself in preparation for the workshop or using the public
rococo testnet. See [Setting Up The Bootnode](../SettingUpTheBootnode.md) for notes on setting up a
cloud-based relay chain.

---

## Using the Docker Images

> You may skip this step if you have built the nodes locally

The two docker images available for this workshop run the exact same binaries that we described
building in the previous section.

- `joshyorndorff/cumulus-workshop-polkadot` is the relay chain node.
- `joshyorndorff/cumulus-workshop-parachain-collator` is the parachain node.

Because these containers will need to communicate with each other, you will need to handle
networking. [Networking in Docker](https://docs.docker.com/network/) is beyond the scope of this
tutorial, and there are many valid options. I'll briefly describe one simple option here that will
help many beginners get up and running fast.

"Host Networking" is the simplest technique and allows commands that look most similar to the ones
given in the workshop. It tells docker to run the nodes without isolating the containers; just like
if you were running local binaries.

```bash
# Instead of running
polkadot --my-args

# You should run
docker run --network host joshyorndorff/cumulus-workshop-polkadot --my-args
```

```bash
# Instead of running
parachain-collator --para-args -- --relay-args

# You should run
docker run --network host joshyorndorff/cumulus-workshop-parachain-collator --para-args -- --relay-args
```

Throughout this workshop when we need to run nodes we will refer to them simply as `polkadot` and
`parachain-collator`. You will need to transform these commands into appropriate docker commands.
