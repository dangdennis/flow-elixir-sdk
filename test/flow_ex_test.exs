defmodule FlowExTest do
  use ExUnit.Case
  doctest FlowEx

  def new_conn() do
    FlowEx.new(%{url: "localhost:3569"})
  end

  test "ping" do
    assert {:ok, %Flow.Access.PingResponse{}} == FlowEx.ping(new_conn())
  end

  test "get_account" do
    assert {:ok, %Flow.Access.AccountResponse{}} =
             FlowEx.get_account(new_conn(), "f8d6e0586b0a20c7")

    assert {:ok, %Flow.Access.AccountResponse{}} =
             FlowEx.get_account(new_conn(), "F8D6E0586B0A20C7")
  end

  test "get_latest_block" do
    assert {:ok, %Flow.Access.BlockResponse{}} = FlowEx.get_latest_block(new_conn())
  end

  @tag disabled: true
  test "execute_scripts" do
    test_script = """
    pub fun main(): Int { return 1 }
    """

    assert {:ok, _} = FlowEx.execute_script(new_conn(), test_script)
  end
end
