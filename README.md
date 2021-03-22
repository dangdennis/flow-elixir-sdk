# 💪 Flex 💪 the Flow Elixir SDK

:construction: Not production ready. At all. :construction:

Elixir SDK for the Flow blockchain. For those that desire to build an Elixir app without requiring a Node or Go server sitting in-between their blockchain and favorite server language.

Short term goals:

1. Read-only operations: i.e. send Cadence scripts to Flow via its gprc gateway.
2. Listen to Flow events.

Long term goals:

1. Encrypt and send transactions
2. Meet feature parity with JS and Go SDK as necessary.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `flow_flex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:flow_flex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/flow_flex](https://hexdocs.pm/flow_flex).

## Learning Resources

-   https://github.com/elixir-grpc/grpc/tree/master/examples
-   https://github.com/elixir-grpc/grpc/blob/master/examples/helloworld/priv/client.exs
-   https://www.onflow.org/post/interact-with-flow-using-ruby
-   https://github.com/elixir-grpc/grpc
-   https://github.com/elixir-protobuf/protobuf
-   https://github.com/onflow/flow-emulator/blob/master/README.md#starting-the-server

## Development

1. Run `git submodule init` initialize the git submodule.
2. Run `git submodule update --remote` to pull the latest commit (though we expect the contracts to infrequently if ever change).
3. If there are changes to the Flow contracts, re-generate Elixir code from the protobufs. See [Protobuf Generation](#-Protobuf-Generation).
4. Install the [Flow CLI](https://docs.onflow.org/flow-cli/install).
5. Run `flow emulator start`

## Protobuf Generation

See [Generate Elixir code](https://github.com/elixir-protobuf/protobuf#generate-elixir-code) in Elixir-Protobuf for more details.

1. `brew install protobuf`
2. `protoc -I flow/protobuf/ --elixir_out=plugins=grpc:./lib/ flow/protobuf/flow/**/*.proto`
