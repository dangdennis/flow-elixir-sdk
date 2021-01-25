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

  def ping(channel) do
    Flow.Access.AccessAPI.Stub.ping(channel, Flow.Access.PingRequest.new())
  end

  def get_account(channel, address) when is_binary(address) do
    # Flow works with 16-bit addresses. To decode as 16-bits, we must uppercase any alpha A-F.
    addr = address |> Base.decode16!(case: :mixed)

    Flow.Access.AccessAPI.Stub.get_account_at_latest_block(
      channel,
      Flow.Access.GetAccountAtLatestBlockRequest.new(address: addr)
    )
  end

  def get_latest_block(channel) do
    Flow.Access.AccessAPI.Stub.get_latest_block(channel, Flow.Access.GetLatestBlockRequest.new())
  end

  def execute_script(channel, scripts, args \\ []) do
    Flow.Access.AccessAPI.Stub.execute_script_at_latest_block(
      channel,
      Flow.Access.ExecuteScriptAtLatestBlockRequest.new(scripts: scripts, args: args)
    )
  end
end
