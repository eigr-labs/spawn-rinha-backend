defmodule SpawnRinhaEx.Actors.Client do
  @moduledoc """

  """
  alias Io.Eigr.Spawn.Rinha.CreditMessage, as: Credit
  alias Io.Eigr.Spawn.Rinha.DebitMessage, as: Debit

  def credit(id, value, description) do
    if id in 1..5 do
      SpawnSdk.invoke("#{id}",
        action: "credit",
        system: "spawn-rinha",
        payload: %Credit{value: value, description: description}
      )
    else
      {:error, :invalid_id}
    end
  end

  def debit(id, value, description) do
    if id in 1..5 do
      SpawnSdk.invoke("#{id}",
        action: "debit",
        system: "spawn-rinha",
        payload: %Debit{value: value, description: description}
      )
    else
      {:error, :invalid_id}
    end
  end

  def statement(id) do
  end
end
