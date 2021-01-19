defmodule FlowExTest do
  use ExUnit.Case
  doctest FlowEx

  test "greets the world" do
    assert FlowEx.hello() == :world
  end
end
