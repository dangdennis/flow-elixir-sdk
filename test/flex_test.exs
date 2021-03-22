defmodule FlexTest do
  use ExUnit.Case
  doctest Flex

  alias FlexT

  def new_conn() do
    Flex.new(%{url: "localhost:3569"})
  end

  @tag disabled: false
  test "ping" do
    assert {:ok, %Flow.Access.PingResponse{}} == Flex.ping(new_conn())
  end

  @tag disabled: false
  test "get_account" do
    assert {:ok, %Flow.Access.AccountResponse{}} =
             Flex.get_account(new_conn(), "f8d6e0586b0a20c7")

    assert {:ok, %Flow.Access.AccountResponse{}} =
             Flex.get_account(new_conn(), "F8D6E0586B0A20C7")
  end

  @tag disabled: false
  test "get_latest_block" do
    assert {:ok, %Flow.Access.BlockResponse{}} = Flex.get_latest_block(new_conn())
  end

  @tag disabled: false
  test "execute_scripts returns" do
    script = """
    pub fun main(): Int { return 1 }
    """

    assert {:ok, val} = Flex.execute_script(new_conn(), script)
    assert val == 1
  end

  test "execute_scripts returns expected number" do
    script = """
    pub fun main(): Int { return 5 }
    """

    assert {:ok, val} = Flex.execute_script(new_conn(), script)
    assert val == 5
  end

  @tag disabled: false
  test "execute_scripts error" do
    script = """
    fun main(): Int { return 1 }
    """

    assert {:error, _} = Flex.execute_script(new_conn(), script)
  end
end
