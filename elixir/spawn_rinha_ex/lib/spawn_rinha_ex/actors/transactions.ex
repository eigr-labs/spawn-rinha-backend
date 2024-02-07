defmodule SpawnRinhaEx.Actors.Account do
  @moduledoc """

  """
  use SpawnSdk.Actor,
    name: "transactions",
    kind: :unnamed,
    state_type: Io.Eigr.Spawn.Rinha.AccountTransactionsState

  require Logger

  alias Io.Eigr.Spawn.Rinha.AccountTransactionsState

  defact init(ctx) do
    if is_nil(ctx.state) do
      Logger.info("Initializing Account Transactions")

      Value.of()
      |> Value.state(%AccountTransactionsState{transactions: []})
    else
      Logger.info("Reactivating Account Transactions")

      Value.of()
    end
  end

  defact credit(
           %Credit{value: value} = data,
           %Context{state: state} = ctx
         ) do
    Logger.info("Received Credit Request: #{inspect(data)}. Context: #{inspect(ctx)}")

    new_balance = ctx.state.balance + value

    Value.of(%Credit{value: new_balance}, %AccountState{balance: new_balance})
  end

  defact debit(
           %Debit{value: value} = data,
           %Context{state: state} = ctx
         ) do
    Logger.info("Received Debit Request: #{inspect(data)}. Context: #{inspect(ctx)}")

    new_balance = ctx.state.balance - value

    if new_balance < (ctx.state.limit * -1) do
      Logger.error("Debit request denied. Limit exceeded. Context: #{inspect(ctx)}")

      Value.of(%Debit{value: value}, ctx.state)
    else
      Value.of(%Debit{value: new_balance}, %AccountState{balance: new_balance})
    end
    |> Value.forward(
      Forward.to(
        "#{ctx.self.name}-transactions",
        "create"
      )
    )
  end
end
