# Interact with your Parachain

The entire point of launching and registering parachains is that we can submit transactions to the
parachains and interact with them.

## Connecting with the Apps UI

We've already connected the Apps UI to the relay chain node. Now we can also connect to the
parachain collator. Open another instance of Apps in a new browser window, and connect it to the
appropriate endpoint. If you have followed these instructions so far, you can connect to the
parachain node at:

https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A8844#/

## Submit Transactions

You can make some simple token transfers to ensure that the parachain is operating normally. You can
also make some on-chain remarks by going to the `Extrinsics` page, choosing `System` pallet and
`remark` extrinsic.

If the transaction go through as expected, you have a working parachain!

## Cross-chain Message Passing (XCMP)

A parachain is it's own chain, but one key feature of connecting to a _common_ relaychain is the
ability to communicate _between_ the connected chains. This area of functionality at the cutting
edge development, and for now is not implemented in this workshop. A few things to keep
in mind when interacting with various connected chains:

- The relay chain has no parachain state, so you cannot query parachain data through the relay chain.
  Only Proof of Validity (PoV) information resides in relay chain storage: the Wasm runtime
  validation functions and the PoV headers.

- The relaychain is not the place to submit extrinsics or gather events data about parachains
  and vice versa. You should communicate with a collator node directly for parachain operations.
  Systems and possibly common-good parachains maybe accessible directly from relaychain for
  extrinsics and events. But in general, this is more of the exception rather than the rule.

- Vertical message passing (VMP) will eventually be allowed for.

For a detailed overview, see the [Polkadot wiki on XCMP](https://wiki.polkadot.network/docs/en/learn-crosschain)
