# Starting the Relay Chain

Before we can attach any cumulus-based parachains, we need to launch a relay chain to connect to.
This page describes in detail how to start both nodes using the two-validator `rococo-custom-2-raw.json`
chain spec that ships with this workshop as well as the general instructions for starting additional
nodes.

## Start Alice's Node

```bash
# Start Relay `Alice` node
./target/release/polkadot \
--alice \
--validator \
--base-path /tmp/relay/alice \
--chain <path to spec json> \
--port 30333 \
--ws-port 9944
```

The port and websocket port specified here are the defaults and thus those flags can be omitted.
However we've chosen to leave them in to enforce the habit of checking their values. Because Alice
is using the defaults, no other nodes on the relay chain or parachains can use these ports.

When the node starts you will see several log messages. **Take note of the node's Peer ID**
in the logs. We will need it when connecting other nodes to it. It will look something like
this:

```bash
🏷 Local node identity is: 12D3KooWGjsmVmZCM1jPtVNp6hRbbkGBK3LADYNniJAKJ19NUYiq
```

## Start Bob's Node

```bash
./target/release/polkadot \
--bob \
--validator \
--base-path /tmp/relay-bob \
--chain <path to spec json> \
--bootnodes /ip4/<Alice IP>/tcp/30333/p2p/<Alice Peer ID> \
--port 30334 \
--ws-port 9945
```

Bob's command is perfectly analogous to Alice's. It differs concretely from Alice's in that Bob has
specified his own base path, provided his own validator keys (`--bob`), and used his own ports.
Finally he has added a `--bootnodes` flag. This bootnodes flag is not strictly necessary if you are
running the entire network on a single local system, but it is necessary when operating over the
network, so I've chosen to leave it in.

## Starting Additional Validators (Optional)

> If you are using the `rococo-custom-2-raw.json` spec, you do not need to start additional nodes.

If you're using the `rococo-custom-3-raw.json` or `rococo-custom-4-raw.json` specs that ship with this workshop you will
need to start one or two more nodes. Again, this command is entirely analogous. You just need to
make sure that nodes on the same physical system do not have conflicting ports or base paths.

```bash
./target/release/polkadot \
--charlie \
--validator \
--base-path /tmp/relay-charlie \
--chain <path to spec json> \
--port 30335 \
--ws-port 9946
```

If your custom chain spec includes self-generated keys, see the
[Substrate private network tutorial](https://substrate.dev/docs/en/tutorials/start-a-private-network/customchain#add-keys-to-keystore)
for details on inserting these keys.
