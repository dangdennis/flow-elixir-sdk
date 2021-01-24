defmodule FlowExTest do
  use ExUnit.Case
  doctest FlowEx

  test "pings Flow" do
    assert {:ok, %Flow.Access.PingResponse{}} ==
             FlowEx.new(%{endpoint: "localhost:3569"}) |> FlowEx.ping()
  end
end
