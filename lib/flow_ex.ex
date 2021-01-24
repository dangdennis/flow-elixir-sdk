defmodule FlowEx do
  use GRPC.Server, service: Flow.Access.AccessAPI.Service

  @moduledoc """
  Documentation for `FlowEx`.
  """

  @doc """
  Create a connection
  """
  def new(%{:endpoint => endpoint}) when is_binary(endpoint) do
    {:ok, channel} = GRPC.Stub.connect(endpoint, interceptors: [GRPC.Logger.Client])
    channel
  end

  def ping(channel) do
    Flow.Access.AccessAPI.Stub.ping(channel, Flow.Access.PingRequest.new()) |> IO.inspect()
  end
end
