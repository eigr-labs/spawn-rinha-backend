defmodule SpawnRinhaEx.Api.Routes.Clients do
  @moduledoc """
  Spawn HTTP Endpoints
  """
  use SpawnRinhaEx.Api.Routes.Base

  require Logger

  alias Io.Eigr.Spawn.Rinha.TransactionResponse
  alias SpawnRinhaEx.Api.Views.TransactionsView
  alias SpawnRinhaEx.Actors.Client

  @content_type "application/json"

  get "/:id/extrato" do
    with {:ok, statement} <- Client.statement(String.to_integer(id)),
         {:ok, result} <- TransactionsView.build_transactions_summary(statement) do
      send!(conn, 200, result, @content_type)
    else
      {:error, :invalid_id} ->
        send!(conn, 404, %{}, @content_type)

      _ ->
        send!(conn, 500, %{}, @content_type)
    end
  end

  post "/:id/transacoes" do
    conn.body_params
    |> create_transaction(String.to_integer(id))
    |> case do
      {:error, :invalid_id} ->
        send!(conn, 404, %{}, @content_type)

      {:error, :invalid_id} ->
        send!(conn, 422, %{}, @content_type)

      {:ok, %TransactionResponse{status: :LIMIT_EXCEEDED}} ->
        send!(conn, 422, %{}, @content_type)

      {:ok, result} ->
        {:ok, response} = TransactionsView.build_transaction_response(result)
        send!(conn, 200, response, @content_type)

      _ ->
        send!(conn, 422, %{}, @content_type)
    end
  end

  defp create_transaction(%{"valor" => value, "descricao" => description, "tipo" => type}, id) do
    case type do
      "c" ->
        Client.credit(id, value, description)

      "d" ->
        Client.debit(id, value, description)

      _ ->
        {:error, :invalid_type}
    end
  end
end
