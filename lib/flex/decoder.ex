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

  def decode(%{"type" => "Array", "value" => val}) do
    Enum.map(val, fn v ->
      decode(v)
    end)
  end

  def decode(%{"type" => "Dictionary", "value" => [val]}) do
    key = Map.get(val, "key") |> decode
    key_value = Map.get(val, "value") |> decode

    %{key => key_value}
  end

  def decode(%{"type" => "Resource", "value" => val}) do
    {id, fields} = extract_composite(val)
    {:resource, id, fields}
  end

  def decode(%{"type" => "Struct", "value" => val}) do
    {id, fields} = extract_composite(val)
    {:struct, id, fields}
  end

  def decode(%{"type" => "Event", "value" => val}) do
    {id, fields} = extract_composite(val)
    {:event, id, fields}
  end

  def decode(%{"type" => "Contract", "value" => val}) do
    {id, fields} = extract_composite(val)
    {:contract, id, fields}
  end

  def decode(%{"type" => "Enum", "value" => val}) do
    {id, fields} = extract_composite(val)
    {:enum, id, fields}
  end

  def decode(%{
        "type" => "Path",
        "value" => %{
          "domain" => domain,
          "identifier" => identifier
        }
      }) do
    {:path, domain, identifier}
  end

  def decode(%{
        "type" => "Type",
        "value" => %{
          "staticType" => static_type
        }
      }) do
    {:type, static_type}
  end

  def decode(%{
        "type" => "Capability",
        "value" => %{
          "path" => path,
          "address" => addr,
          "borrowType" => borrow_type
        }
      }) do
    {:capability,
     %{
       path: path,
       address: addr,
       borrow_type: borrow_type
     }}
  end

  defp extract_composite(%{"id" => id, "fields" => fields}) do
    {id,
     fields
     |> Enum.reduce(%{}, fn %{"name" => name, "value" => value}, acc ->
       Map.put(acc, name, decode(value))
     end)}
  end
end
