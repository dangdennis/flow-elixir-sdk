defmodule Flex do
  use GRPC.Server, service: Flow.Access.AccessAPI.Service

  @moduledoc """
  Documentation for `Flex`.
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

  @spec execute_script(GRPC.Channel.t(), binary(), []) :: {:ok, any()} | {:error, any()}
  def execute_script(channel, script, args \\ []) do
    case Flow.Access.AccessAPI.Stub.execute_script_at_latest_block(
           channel,
           Flow.Access.ExecuteScriptAtLatestBlockRequest.new(
             script: script,
             args: args
           )
         ) do
      {:ok,
       %Flow.Access.ExecuteScriptResponse{
         value: value
       }} ->
        case Jason.decode(value) do
          {:ok, map} -> {:ok, Flex.Decoder.decode(map)}
        end

      {:error, err} ->
        {:error, err}
    end
  end
end
