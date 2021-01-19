# FlowEx

Elixir SDK for the Flow blockchain.

## Inspiration
I desired to build an Elixir app without requiring a Node or Go server sitting in between the blockchain and my main workhorse. 

https://www.onflow.org/post/interact-with-flow-using-ruby

## Short-term goals 
1. Send signed Cadence transactions and scripts to Flow via its gprc gateway.
2. Listen to Flow events

## Long-term goals
Meet feature parity with JS and Go SDK as necessary.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `flow_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:flow_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/flow_ex](https://hexdocs.pm/flow_ex).

