defmodule FlexTest do
  use ExUnit.Case
  doctest Flex

  def emulator_conn() do
    Flex.new(%{url: "localhost:3569"})
  end

  def testnet_conn() do
    Flex.new(%{url: "access-testnet.onflow.org"})
  end

  @tag disabled: false
  test "ping" do
    assert {:ok, %Flow.Access.PingResponse{}} == Flex.ping(emulator_conn())
  end

  @tag disabled: false
  test "get_account" do
    assert {:ok, %Flow.Access.AccountResponse{}} =
             Flex.get_account(emulator_conn(), "f8d6e0586b0a20c7")

    assert {:ok, %Flow.Access.AccountResponse{}} =
             Flex.get_account(emulator_conn(), "F8D6E0586B0A20C7")
  end

  @tag disabled: false
  test "get_latest_block" do
    assert {:ok, %Flow.Access.BlockResponse{}} = Flex.get_latest_block(emulator_conn())
  end

  @tag disabled: false
  test "execute_scripts returns" do
    script = """
    pub fun main(): Int? { return nil }
    """

    assert {:ok, val} = Flex.execute_script(emulator_conn(), script)
    assert val == nil
  end

  @tag disabled: false
  test "execute_scripts returns expected optional number" do
    script = """
    pub fun main(): Int? { return 1 }
    """

    assert {:ok, val} = Flex.execute_script(emulator_conn(), script)
    assert val == 1
  end

  @tag disabled: false
  test "execute_scripts returns expected number" do
    script = """
    pub fun main(): Int { return 5 }
    """

    assert {:ok, val} = Flex.execute_script(emulator_conn(), script)
    assert val == 5
  end

  @tag disabled: false
  test "execute_scripts error" do
    script = """
    fun main(): Int { return 1 }
    """

    assert {:error, _} = Flex.execute_script(emulator_conn(), script)
  end

  @tag disabled: false
  test "get_events_for_height_range returns results" do
    assert {:ok, _} = Flex.get_events_for_height_range(emulator_conn(), "BadgeMinted", 0, 100)
  end

  @tag disabled: false
  test "get_network_parameters returns chain id" do
    assert {:ok, %Flow.Access.GetNetworkParametersResponse{chain_id: "flow-emulator"}} =
             Flex.get_network_parameters(emulator_conn())
  end
end
