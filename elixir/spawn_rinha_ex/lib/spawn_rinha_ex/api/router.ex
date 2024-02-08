defmodule SpawnRinhaEx.Api.Router do
  @moduledoc false
  use Plug.Router

  alias SpawnRinhaEx.Api.Routes.{Clients, Health}

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  forward("/clientes", to: Clients)

  forward("/health", to: Health)

  match _ do
    send_resp(conn, 404, "Not found!")
  end
end
