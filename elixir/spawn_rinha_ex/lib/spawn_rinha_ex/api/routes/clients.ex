defmodule SpawnRinhaEx.Api.Routes.Clients do
  @moduledoc """
  Spawn HTTP Endpoints
  """
  use SpawnRinhaEx.Api.Routes.Base

  require Logger

  alias Io.Eigr.Spawn.Rinha.TransactionResponse
  alias SpawnRinhaEx.Actors.Client

  @content_type "application/json"

  get "/:id/extrato" do
    with {:ok, statement} <- Client.statement(id),
         {:ok, result} <- transform(statement) do
      send!(conn, 200, result, @content_type)
    else
      {:error, :invalid_id} ->
        send!(conn, 404, %{}, @content_type)

      _ ->
        send!(conn, 500, %{}, @content_type)
    end
  end

  post "/:id/transacoes" do
    %{"valor" => value, "descricao" => description, "tipo" => type} = conn.body_params

    cond do
      type == "c" ->
        case Client.credit(id, value, description) do
          {:ok, %TransactionResponse{status: :LIMIT_EXCEEDED}} ->
            send!(conn, 422, %{}, @content_type)

          {:ok, result} ->
            success_response(conn, result)

          {:error, :invalid_id} ->
            send!(conn, 404, %{}, @content_type)

          _ ->
            send!(conn, 500, %{}, @content_type)
        end

      type == "d" ->
        case Client.debit(id, value, description) do
          {:ok, %TransactionResponse{status: :LIMIT_EXCEEDED}} ->
            send!(conn, 422, %{}, @content_type)

          {:ok, result} ->
            success_response(conn, result)

          {:error, :invalid_id} ->
            send!(conn, 404, %{}, @content_type)

          _ ->
            send!(conn, 500, %{}, @content_type)
        end

      true ->
        send!(conn, 422, %{}, @content_type)
    end
  end

  defp success_response(conn, %TransactionResponse{status: :OK} = result) do
    send!(
      conn,
      200,
      %{
        limite: result.limit,
        saldo: result.balance
      },
      @content_type
    )
  end

  defp transform(statement) do
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

  defp transform_transaction(%Io.Eigr.Spawn.Rinha.Transaction{} = transaction) do
    %{
      valor: transaction.value,
      descricao: transaction.description,
      tipo: if(transaction.type == :CREDIT, do: "c", else: "d"),
      realizada_em: transaction.date
    }
  end
end
