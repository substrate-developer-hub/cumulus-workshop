### The Builder Stage Compiles the code
FROM parity/rust-builder as builder

# Clone the template code and checkout the right commit
RUN git clone https://github.com/substrate-developer-hub/substrate-parachain-template.git
WORKDIR /builds/substrate-parachain-template
RUN git checkout 9506b93

# Build the Parachain Collator node
RUN cargo build --release

### The final stage just copies binary and chainspecs

# Choose the base image. Same on used in main Polkadot repo
FROM debian:stretch-slim

# Copy the node into the image
COPY --from=builder /builds/substrate-parachain-template/target/release/parachain-collator .

## Copy chainspecs into the image
COPY shared/chainspecs/rococo-custom-2-raw.json .
COPY shared/chainspecs/rococo-custom-3-raw.json .
COPY shared/chainspecs/rococo-custom-4-raw.json .

# Open default ports. User is responsible for re-mapping these
# or using host or overlay networking.
EXPOSE 30333 9933 9944

ENTRYPOINT ["./parachain-collator"]
