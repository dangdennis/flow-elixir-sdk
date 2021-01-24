defmodule FlowEx do
  use GRPC.Server, service: Flow.Access.AccessAPI.Service

  @moduledoc """
  Documentation for `FlowEx`.
  """

  @doc """
  Create a connection
  """
  def new() do
  end

  def ping() do
    # Am I supposed to store channels? If so, must use a genserver
    {:ok, channel} = GRPC.Stub.connect("localhost:3569", interceptors: [GRPC.Logger.Client])

    IO.inspect(channel)

    Flow.Access.AccessAPI.Stub.ping(channel, Flow.Access.PingRequest.new()) |> IO.inspect()
  end
end
