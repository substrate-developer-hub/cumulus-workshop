# Build Spec
./target/release/polkadot build-spec --chain rococo-local --disable-default-bootnode > rococo-custom-2-plain.json
./target/release/polkadot build-spec --chain rococo-custom-2-plain.json --raw --disable-default-bootnode > rococo-custom-2-raw.json

# modify from snipets to copy and make 3 & 4 validator plain specs

./target/release/polkadot build-spec --chain rococo-custom-3-plain.json --raw --disable-default-bootnode > rococo-custom-3-raw.json
./target/release/polkadot build-spec --chain rococo-custom-4-plain.json --raw --disable-default-bootnode > rococo-custom-4-raw.json

# Relay Validators
./target/release/polkadot --alice --validator --base-path /tmp/relay/alice --chain ../cumulus-workshop/shared/chainspecs/rococo-custom.json --port 30333 --ws-port 9944

./target/release/polkadot --bob --validator --base-path /tmp/relay/bob --chain ../cumulus-workshop/shared/chainspecs/rococo-custom.json --port 30334 --ws-port 9945

# ./target/release/polkadot --charlie --validator --base-path /tmp/relay/charlie --chain ../cumulus-workshop/shared/chainspecs/rococo-custom.json --port 30335 --ws-port 9946


# Parachain collators:
./target/release/parachain-collator --alice --collator --force-authoring --parachain-id 2000 --base-path /tmp/parachain/alice --port 40333 --ws-port 8844 -- --execution wasm --chain ../cumulus-workshop/shared/chainspecs/rococo-custom.json --port 30343 --ws-port 9977
