defmodule SpawnRinhaEx.Api.Routes.Base do
  @moduledoc """
  Base Plug Router for all other plugs
  """
  defmacro __using__([]) do
    quote do
      use Plug.Router

      plug(:match)

      plug(Plug.Parsers,
        parsers: [:json],
        pass: ["text/*"],
        json_decoder: Jason
      )

      plug(:dispatch)

      def send!(conn, code, data, content_type) when is_atom(code) do
        code =
          case code do
            :ok -> 200
            :not_found -> 404
            :malformed_data -> 400
            :non_authenticated -> 401
            :forbidden_access -> 403
            :server_error -> 500
            :service_unavailable -> 503
            :error -> 504
          end

        send!(conn, code, data, content_type)
      end

      def send!(conn, code, data, content_type)
          when is_integer(code) and content_type == "application/json" do
        conn
        |> Plug.Conn.put_resp_content_type(content_type)
        |> Plug.Conn.put_resp_header("Connection", "Keep-Alive")
        |> send_resp(code, Jason.encode!(data))
      end
    end
  end
end
