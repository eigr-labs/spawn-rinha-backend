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
      {:error, not_found} ->
        send!(conn, 404, %{}, @content_type)

      _ ->
        send!(conn, 500, %{}, @content_type)
    end
  end

  post "/:id/transacoes" do
  end

  defp transform(statement) do
    {:ok, %{}}
  end
end
