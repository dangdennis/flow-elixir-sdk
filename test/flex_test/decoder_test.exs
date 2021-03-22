defmodule FlexTest.Decoder do
  use ExUnit.Case
  doctest Flex

  test "decoder" do
    assert Flex.Decoder.decode(%{"type" => "Int", "value" => "1"}) == 1
  end
end
