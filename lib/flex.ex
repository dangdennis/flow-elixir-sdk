defmodule Flex do
  use GRPC.Server, service: Flow.Access.AccessAPI.Service

  @moduledoc """
  Documentation for `Flex`.
  """

  @spec new(%{url: binary}) :: GRPC.Channel.t()
  @doc """
  Create a network connection.
  """
  def new(%{:url => url}) when is_binary(url) do
    {:ok, channel} = GRPC.Stub.connect(url, interceptors: [GRPC.Logger.Client])
    channel
  end

  @doc """
  Ping Flow.
  """
  def ping(channel) do
    Flow.Access.AccessAPI.Stub.ping(channel, Flow.Access.PingRequest.new())
  end

  @spec get_account(GRPC.Channel.t(), binary()) :: {:ok, Flow.Access.AccountResponse}
  def get_account(channel, address) when is_binary(address) do
    # Flow works with 16-bit addresses. To decode as 16-bits, we must uppercase any alpha A-F.
    addr = address |> Base.decode16!(case: :mixed)

    Flow.Access.AccessAPI.Stub.get_account_at_latest_block(
      channel,
      Flow.Access.GetAccountAtLatestBlockRequest.new(address: addr)
    )
  end

  @spec get_latest_block(GRPC.Channel.t()) :: {:ok, Flow.Access.BlockResponse} | {:error, any()}
  def get_latest_block(channel) do
    Flow.Access.AccessAPI.Stub.get_latest_block(channel, Flow.Access.GetLatestBlockRequest.new())
  end

  @spec execute_script(GRPC.Channel.t(), binary(), [any()]) :: {:ok, any()} | {:error, any()}
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

  @spec get_events_for_height_range(GRPC.Channel.t(), binary(), integer(), integer()) ::
          {:ok, [Flow.Access.EventsResponse.Result.t()]} | {:error, any()}
  def get_events_for_height_range(channel, event_type, start_height, end_height) do
    case(
      Flow.Access.AccessAPI.Stub.get_events_for_height_range(
        channel,
        Flow.Access.GetEventsForHeightRangeRequest.new(
          type: event_type,
          start_height: start_height,
          end_height: end_height
        )
      )
    ) do
      {:ok,
       %Flow.Access.EventsResponse{
         results: results
       }} ->
        {:ok, results}

      {:error, err} ->
        {:error, err}
    end
  end

  @spec get_network_parameters(GRPC.Channel.t()) ::
          {:ok, Flow.Access.GetNetworkParametersResponse} | {:error, any()}
  def get_network_parameters(channel) do
    Flow.Access.AccessAPI.Stub.get_network_parameters(
      channel,
      Flow.Access.GetNetworkParametersRequest.new()
    )
  end
end
