defmodule FlowEx do
  use GRPC.Server, service: Flow.Access.AccessAPI.Service

  @moduledoc """
  Documentation for `FlowEx`.
  """

  @spec new(%{url: binary}) :: GRPC.Channel.t()
  @doc """
  Create a connection
  """
  def new(%{:url => url}) when is_binary(url) do
    {:ok, channel} = GRPC.Stub.connect(url, interceptors: [GRPC.Logger.Client])
    channel
  end

  @spec ping(GRPC.Channel.t()) ::
          {:error, GRPC.RPCError.t()} | {:ok, any} | {:ok, any, map} | GRPC.Client.Stream.t()
  def ping(channel) do
    Flow.Access.AccessAPI.Stub.ping(channel, Flow.Access.PingRequest.new())
  end

  def get_account(channel, address) when is_binary(address) do
    # query latest block height

    Flow.Access.AccessAPI.Stub.get_account_at_latest_block(
      channel,
      # need to get latest block height
      Flow.Access.GetAccountAtBlockHeightRequest.new(address: address, block_height: 0)
    )
  end

  def get_latest_block(channel) do
    Flow.Access.AccessAPI.Stub.get_latest_block(channel, Flow.Access.GetLatestBlockRequest.new())
  end

  def execute_script(channel, scripts, args) do
    Flow.Access.AccessAPI.Stub.execute_script_at_latest_block(
      channel,
      Flow.Access.ExecuteScriptAtLatestBlockRequest.new(scripts: scripts, args: args)
    )
  end

  def execute_script(channel, scripts) do
    IO.inspect(scripts)

    Flow.Access.AccessAPI.Stub.execute_script_at_latest_block(
      channel,
      Flow.Access.ExecuteScriptAtLatestBlockRequest.new(scripts: scripts)
    )
  end
end
