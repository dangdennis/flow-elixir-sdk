defmodule FlexTest.Decoder do
  use ExUnit.Case
  doctest Flex

  alias Flex.Decoder

  @tag disabled: false
  test "decoder decodes" do
    assert %{"type" => "Int", "value" => "1"}
           |> Decoder.decode() == 1
  end

  test "void" do
    assert %{
             "type" => "Void"
           }
           |> Decoder.decode() == nil
  end

  test "optional nil" do
    assert %{
             "type" => "Optional",
             "value" => nil
           }
           |> Decoder.decode() == nil
  end

  test "optional non-nil" do
    assert %{
             "type" => "Optional",
             "value" => %{
               "type" => "Int8",
               "value" => "123"
             }
           }
           |> Decoder.decode() == 123
  end

  test "boolean true" do
    assert %{
             "type" => "Bool",
             "value" => true
           }
           |> Decoder.decode() == true
  end

  test "boolean false" do
    assert %{
             "type" => "Bool",
             "value" => false
           }
           |> Decoder.decode() == false
  end

  test "string empty" do
    assert %{
             "type" => "String",
             "value" => ""
           }
           |> Decoder.decode() == ""
  end

  test "string exist" do
    assert %{
             "type" => "String",
             "value" => "snargle-blob"
           }
           |> Decoder.decode() == "snargle-blob"
  end

  test "address" do
    assert %{
             "type" => "Address",
             "value" => "0x1234"
           }
           |> Decoder.decode() == "0x1234"
  end

  test "[U]Int, [U]Int8, [U]Int16, [U]Int32,[U]Int64,[U]Int128, [U]Int256,  Word8, Word16, Word32, or Word64" do
    assert %{
             "type" => "Int",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int8",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt8",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int16",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt16",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int32",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt32",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int64",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt64",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int128",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt128",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Int256",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "UInt256",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word8",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word16",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word32",
             "value" => "1"
           }
           |> Decoder.decode() == 1

    assert %{
             "type" => "Word64",
             "value" => "1"
           }
           |> Decoder.decode() == 1
  end

  test "[U]Fix64" do
    assert %{
             "type" => "Fix64",
             "value" => "1312.41212"
           }
           |> Decoder.decode() == 1312.41212

    assert %{
             "type" => "UFix64",
             "value" => "-1312.4121299999999"
           }
           |> Decoder.decode() == -1312.4121299999999
  end
end
