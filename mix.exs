defmodule Flex.MixProject do
  use Mix.Project

  def project do
    [
      app: :flex,
      version: "0.1.0",
      elixir: "~> 1.11",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: """
      The Elixir client SDK for the Flow blockchain.
      """
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      maintainers: ["Dennis Dang"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://https://github.com/dangdennis/flow-elixir-sdk"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:grpc, github: "elixir-grpc/grpc"},
      {:google_protos, "~> 0.1"},
    #   {:ex_rlp, ">= 0.0.0"},
      {:protobuf, github: "tony612/protobuf-elixir", override: true},
      {:cowlib, "~> 2.9.0", override: true},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false}
    ]
  end
end
