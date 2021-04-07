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
    addr = address |> Flex.Utils.remove_prefix() |> Base.decode16!(case: :mixed)

    channel
    |> Flow.Access.AccessAPI.Stub.get_account_at_latest_block(
      Flow.Access.GetAccountAtLatestBlockRequest.new(address: addr)
    )
    |> case do
      {:ok, %Flow.Access.AccountResponse{account: account}} -> {:ok, account}
      {:error, err} -> {:error, err}
    end
  end

  @spec get_latest_block(GRPC.Channel.t()) :: {:ok, Flow.Entities.Block.t()} | {:error, any()}
  def get_latest_block(channel) do
    Flow.Access.AccessAPI.Stub.get_latest_block(channel, Flow.Access.GetLatestBlockRequest.new())
    |> case do
      {:ok, %Flow.Access.BlockResponse{block: block}} -> {:ok, block}
      {:error, err} -> {:error, err}
    end
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

  #   @spec create_account(%{channel: GRPC.Channel.t(), key_index: integer(), private_key: binary()}) :: any()
  def create_account(channel, %{address: addr, key_index: key_idx, private_key: pk}) do
    code = """
    transaction(publicKey: String) {
        let payer: AuthAccount
        prepare(payer: AuthAccount) {
          self.payer = payer
        }
        execute {
          let account = AuthAccount(payer: self.payer)
          account.addPublicKey(publicKey.decodeHex())
        }
      }
    """

    {:ok, service_addr} = Flex.get_account(channel, addr)

    IO.inspect(service_addr)

    {:ok, %Flow.Entities.AccountKey{} = acct_key} = Enum.fetch(service_addr.keys, key_idx)

    IO.inspect(acct_key)

    {:ok, %Flow.Entities.Block{} = block} = Flex.get_latest_block(channel)

    # proposal_key =
    #   Flow.Entities.Transaction.ProposalKey.new(%{
    #     address: service_addr.address,
    #     key_id: key_idx,
    #     sequence_number: acct_key.sequence_number
    #   })

    # args = [
    #   %{
    #     type: "Array",
    #     value: [
    #       %{
    #         type: "String",
    #         value:
    #           Flow.Entities.AccountKey.new(%{
    #             public_key: Base.decode16!(acct_key.public_key, case: :mixed),
    #             weight: 1000,
    #             sign_algo: 2,
    #             hash_algo: 3
    #           })
    #           |> ExRLP.encode(encoding: :hex)
    #       }
    #     ]
    #   },
    #   %{type: "Dictionary", value: []}
    # ]

    # decoded_addr = Base.decode16!(addr, case: :mixed)

    # transaction =
    #   Flow.Entities.Transaction.new(%{
    #     script: code,
    #     arguments: Jason.encode!(args),
    #     authorizers: [decoded_addr],
    #     payer: [decoded_addr],
    #     proposal_key: proposal_key,
    #     reference_block_id: block.id,
    #   })

    # transaction |> IO.inspect()
  end

  #   def send_transaction(channel, ) do
  #     transaction = Flow.Entities.Transaction.new(%{
  #         script: binary,
  #         arguments: [binary],
  #         reference_block_id: binary,
  #         gas_limit: non_neg_integer,
  #         proposal_key: Flow.Entities.Transaction.ProposalKey.t() | nil,
  #         payer: binary,
  #         authorizers: [binary],
  #         payload_signatures: [Flow.Entities.Transaction.Signature.t()],
  #         envelope_signatures: [Flow.Entities.Transaction.Signature.t()]
  #       })

  #     Flow.Access.AccessAPI.Stub.send_transaction(channel,
  #         Flow.Access.SendTransactionRequest.new(
  #             %{transaction: transaction}

  #         ),
  #     )
  #   end
end
