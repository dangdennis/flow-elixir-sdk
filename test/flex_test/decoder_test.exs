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
end
