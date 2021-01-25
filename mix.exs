defmodule FlowEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :flow_ex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:grpc, github: "elixir-grpc/grpc"},
      {:protobuf, github: "tony612/protobuf-elixir", override: true},
      {:cowlib, "~> 2.9.0", override: true},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false}
    ]
  end
end
