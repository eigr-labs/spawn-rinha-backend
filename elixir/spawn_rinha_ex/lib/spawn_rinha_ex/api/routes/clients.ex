defmodule SpawnRinhaEx.Api.Routes.Clients do
  @moduledoc """
  Spawn HTTP Endpoints
  """
  use SpawnRinhaEx.Api.Routes.Base
  require Logger

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
    {status, body} ->
      case conn.body_params do
        %{"valor" => value, "tipo" => type, "descricao" => description} ->
          do_handle_request(type, id, value, description)

        _ ->
          {422, %{}}
      end

      send(conn, status, body, @content_type)
  end

  defp do_handle_request("c", id, value, description) do
    Client.credit(id, value, description)
  end

  defp do_handle_request("d", id, value, description) do
    Client.debit(id, value, description)
  end

  defp do_handle_request(_, _id, _value, _description) do
  end

  defp transform(statement) do
    {:ok, %{}}
  end
end
