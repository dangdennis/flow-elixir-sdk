defmodule Flex.Decoder do
  def decode(%{"type" => "Int", "value" => val}) do
    String.to_integer(val)
  end
end
