defmodule FlexTest.Decoder do
  use ExUnit.Case
  doctest Flex

  @tag disabled: false
  test "decoder" do
    assert Flex.Decoder.decode(%{"type" => "Int", "value" => "1"}) == 1
  end
end
