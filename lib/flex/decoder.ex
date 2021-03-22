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

  def decode(%{"type" => "Bool", "value" => value}) do
    value
  end

  def decode(%{"type" => "String", "value" => value}) do
    value
  end

  def decode(%{"type" => "Address", "value" => value}) do
    value
  end

  def decode(%{"type" => "Int", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "UInt", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Int8", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "UInt8", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Int16", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "UInt16", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Int32", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "UInt32", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Int64", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "UInt64", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Int128", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "UInt128", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Int256", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "UInt256", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Word8", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Word16", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Word32", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Word64", "value" => val}) do
    String.to_integer(val)
  end

  def decode(%{"type" => "Fix64", "value" => val}) do
    String.to_float(val)
  end

  def decode(%{"type" => "UFix64", "value" => val}) do
    String.to_float(val)
  end
end
