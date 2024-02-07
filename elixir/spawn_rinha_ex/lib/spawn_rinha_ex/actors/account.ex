defmodule SpawnRinhaEx.Actors.Account do
  @moduledoc """

  """
  use SpawnSdk.Actor,
    name: "account",
    kind: :unnamed,
    state_type: Io.Eigr.Spawn.Rinha.AccountState

  require Logger

  alias Io.Eigr.Spawn.Rinha.AccountState
  alias Io.Eigr.Spawn.Rinha.CreditMessage, as: Credit
  alias Io.Eigr.Spawn.Rinha.DebitMessage, as: Debit

  defact credit(
           %Credit{value: value} = data,
           %Context{state: state} = ctx
         ) do
    Logger.info("Received Credit Request: #{inspect(data)}. Context: #{inspect(ctx)}")

    new_value = if is_nil(state), do: value, else: (state.value || 0) + value

    Value.of(%Credit{value: new_value}, %AccountState{balance: new_value})
  end

  defact debit(
           %Debit{value: value} = data,
           %Context{state: state} = ctx
         ) do
    Logger.info("Received Debit Request: #{inspect(data)}. Context: #{inspect(ctx)}")
  end
end
