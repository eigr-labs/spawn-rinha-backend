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

  @id_limit_map %{
    1 => 100_000,
    2 => 80000,
    3 => 1_000_000,
    4 => 10_000_000,
    5 => 500_000
  }

  defact init(ctx) do
    if is_nil(ctx.state) do
      Logger.info("Initializing Account Actor")

      id = String.to_integer(ctx.self.name)

      initial_state = %AccountState{limit: Map.get(@id_limit_map, id, 0), balance: 0}

      Value.of()
      |> Value.state(initial_state)
    else
      Logger.info("Reactivating Account Actor")

      Value.of()
    end
  end

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

    new_balance = ctx.state.balance + value

    Value.of(%Credit{value: new_balance}, %AccountState{balance: new_balance})
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

    new_balance = ctx.state.balance - value

    if new_balance < ctx.state.limit * -1 do
      Logger.error("Debit request denied. Limit exceeded. Context: #{inspect(ctx)}")

      Value.of(%Debit{value: value}, ctx.state)
    else
      Value.of(%Debit{value: new_balance}, %AccountState{balance: new_balance})
    end
  end
end
