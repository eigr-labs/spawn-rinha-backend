defmodule SpawnRinhaEx.Actors.Account do
  @moduledoc """
  Module for handling account-related operations.

  This module defines actors for handling credit and debit operations on an account.

  ## Usage

  1. Start an account actor using SpawnSdk.Actor with `name: "account"` and `kind: :unnamed`.
  2. Use the defined functions `credit/2` and `debit/2` to interact with the account actor.

  """
  use SpawnSdk.Actor,
    name: "account",
    kind: :unnamed,
    state_type: Io.Eigr.Spawn.Rinha.AccountState

  require Logger

  alias Io.Eigr.Spawn.Rinha.AccountState
  alias Io.Eigr.Spawn.Rinha.CreditMessage, as: Credit
  alias Io.Eigr.Spawn.Rinha.DebitMessage, as: Debit

  @doc """
  Handles credit operations on the account.

  ### Parameters:

  - `data` (%Credit{}) - Credit message containing the value to be credited.
  - `ctx` (%Context{}) - Current context containing the state of the account.

  ### Returns:

  Returns a Value with the updated credit message and the new account state.

  """
  defact credit(
           %Credit{value: value} = data,
           %Context{state: state} = ctx
         ) do
    Logger.info("Received Credit Request: #{inspect(data)}. Context: #{inspect(ctx)}")

    new_value = if is_nil(state), do: value, else: (state.value || 0) + value

    Value.of(%Credit{value: new_value}, %AccountState{balance: new_value})
  end

  @doc """
  Handles debit operations on the account.
  Parameters:

      data (%Debit{}) - Debit message containing the value to be debited.
      ctx (%Context{}) - Current context containing the state of the account.

  Returns:

  Returns a value with the updated debit message and the new account state.
  """
  defact debit(
           %Debit{value: value} = data,
           %Context{state: state} = ctx
         ) do
    Logger.info("Received Debit Request: #{inspect(data)}. Context: #{inspect(ctx)}")

    Value.of()
  end
end
