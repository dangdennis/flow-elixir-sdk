# See https://docs.onflow.org/cadence/json-cadence-spec for more details.

defmodule Flex.Utils do
  @moduledoc """
  Utility functions for common Flex operations.
  """

  def remove_prefix("0x" <> addr) do
    addr
  end

  def remove_prefix("0X" <> addr) do
    addr
  end

  def with_prefix(addr) do
    "0x" <> addr
  end
end
