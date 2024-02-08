defmodule SpawnRinhaEx.Api.Views.TransactionsView do
  @moduledoc """
  Views for client routes
  """

  alias Io.Eigr.Spawn.Rinha.Transaction
  alias Io.Eigr.Spawn.Rinha.TransactionResponse
  alias Io.Eigr.Spawn.Rinha.AccountState

  @doc """
  Builds a transaction response
  """
  @spec build_transaction_response(response :: TransactionResponse.t()) :: map()
  def build_transaction_response(%TransactionResponse{} = response) do
    {:ok,
     %{
       limite: response.limit,
       saldo: response.balance
     }}
  end

  @doc """
  Builds a summary of the transactions
  """
  @spec build_transactions_summary(statement :: AccountState.t()) :: {:ok, map()}
  def build_transactions_summary(%AccountState{} = statement) do
    {:ok,
     %{
       saldo: %{
         total: statement.balance,
         data_extrato: DateTime.utc_now() |> DateTime.to_iso8601(),
         limite: statement.limit
       },
       ultimas_transacoes: Enum.map(statement.transactions, &transform_transaction/1)
     }}
  end

  defp transform_transaction(%Transaction{} = transaction) do
    %{
      valor: transaction.value,
      descricao: transaction.description,
      tipo: if(transaction.type == :CREDIT, do: "c", else: "d"),
      realizada_em: transaction.date
    }
  end
end
