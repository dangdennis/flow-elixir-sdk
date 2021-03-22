# See https://docs.onflow.org/cadence/json-cadence-spec for more details.

defmodule Flex.Decoder do
  @moduledoc """
  Decoder decodes the JSON-Cadence Data Interchange Format into a simple JSON format.
  """

  def decode(%{"type" => "Void"}) do
    nil
  end

  def decode(%{"type" => "Optional", "value" => value}) do
    case value do
      nil -> nil
      value -> decode(value)
    end
  end

  def decode(%{"type" => "Int", "value" => val}) do
    IO.puts("decoding integer")
    String.to_integer(val)
  end
end
