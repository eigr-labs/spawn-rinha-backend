defmodule SpawnRinhaEx.Actors.Client do
  @moduledoc """
  Module for interacting with the Spawn Rinha system as a client.

  This module provides functions for performing credit, debit, and statement operations.

  ## Usage

  1. Use the `credit/3` and `debit/3` functions to perform credit and debit transactions.
  2. Utilize the `statement/1` function to retrieve account statements.

  """
  alias Io.Eigr.Spawn.Rinha.CreditMessage, as: Credit
  alias Io.Eigr.Spawn.Rinha.DebitMessage, as: Debit

  @doc """
  Guards against invalid ID ranges.

  ### Parameters:

  - `n` - The value to be checked.
  - `min` - The minimum allowed value.
  - `max` - The maximum allowed value.

  """
  defguard is_range(n, min, max) when n in min..max

  @doc """
  Performs a credit transaction.

  ### Parameters:

  - `id` - The client ID.
  - `value` - The amount to be credited.
  - `description` - A description of the credit transaction.

  ### Returns:

  - `{:error, :invalid_id}` if the ID is outside the valid range.
  - Result of the credit transaction if the ID is valid.

  ### Example:

  ```elixir
  Client.credit(3, 100, "Payment")
  ```

  """
  def credit(id, _value, _description) when not is_range(id, 1, 5), do: {:error, :invalid_id}
  def credit(_id, value, _description) when not is_integer(value), do: {:error, :invalid_id}

  def credit(id, value, description) do
    SpawnSdk.invoke("#{id}",
      action: "credit",
      system: "spawn-rinha",
      payload: %Credit{value: value, description: description}
    )
  end

  @doc """
  Performs a debit transaction.

  ### Parameters:

      id - The client ID.
      value - The amount to be debited.
      description - A description of the debit transaction.

  ### Returns:

      {:error, :invalid_id} if the ID is outside the valid range.
      Result of the debit transaction if the ID is valid.

  ### Example:

  ```elixir
  Client.debit(2, 50, "Purchase")
  ```

  """
  def debit(id, _value, _description) when not is_range(id, 1, 5), do: {:error, :invalid_id}
  def debit(_id, value, _description) when not is_integer(value), do: {:error, :invalid_id}

  def debit(id, value, description) do
    SpawnSdk.invoke("#{id}",
      action: "debit",
      system: "spawn-rinha",
      payload: %Debit{value: value, description: description}
    )
  end

  @doc """
  Retrieves the account statement for a client.

  ### Parameters:

      id - The client ID.

  ### Returns:

  No return value.

  ### Example:

  ```elixir
  Client.statement(4)
  ```

  """
  def statement(id) when not is_range(id, 1, 5), do: {:error, :invalid_id}

  def statement(id) do
    SpawnSdk.invoke("#{id}",
      action: "get_state",
      system: "spawn-rinha"
    )
  end
end
