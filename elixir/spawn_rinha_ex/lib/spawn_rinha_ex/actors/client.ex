defmodule SpawnRinhaEx.Actors.Client do
  @moduledoc """

  """
  alias Io.Eigr.Spawn.Rinha.CreditMessage, as: Credit
  alias Io.Eigr.Spawn.Rinha.DebitMessage, as: Debit

  defguardp is_range(n, min, max) when n in min..max

  def credit(id, value, description) when is_range(id, 1, 5), do: {:error, :invalid_id}

  def credit(id, value, description) do
    SpawnSdk.invoke("#{id}",
      action: "credit",
      system: "spawn-rinha",
      payload: %Credit{value: value, description: description}
    )
  end

  def debit(id, value, description) when is_range(id, 1, 5), do: {:error, :invalid_id}

  def debit(id, value, description) do
    SpawnSdk.invoke("#{id}",
      action: "debit",
      system: "spawn-rinha",
      payload: %Debit{value: value, description: description}
    )
  end

  def statement(id) do
  end
end
