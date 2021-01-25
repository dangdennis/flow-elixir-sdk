defmodule FlowExTest do
  use ExUnit.Case
  doctest FlowEx

  def new_conn() do
    FlowEx.new(%{url: "localhost:3569"})
  end

  test "ping" do
    assert {:ok, %Flow.Access.PingResponse{}} ==
             new_conn() |> FlowEx.ping()
  end

  @tag disabled: true
  test "get_account" do
    assert {:ok, _} = new_conn() |> FlowEx.get_account("0xf8d6e0586b0a20c7")
  end

  @tag disabled: true
  test "get_latest_block" do
    assert {:ok, _} = new_conn() |> FlowEx.get_latest_block()
  end
end
