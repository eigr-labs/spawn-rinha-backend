defmodule SpawnRinhaEx.Api.Routes.Health do
  @moduledoc """
  Health Endpoint.
  """
  use SpawnRinhaEx.Api.Routes.Base

  alias Plug.Conn
  alias Sidecar.GracefulShutdown

  @content_type "application/json"

  get "/" do
    send!(conn, :ok, %{status: "up"}, @content_type)
  end

  get "/liveness" do
    send!(conn, :ok, %{status: "up"}, @content_type)
  end

  get "/readiness" do
    conn
    |> send!(:ok, %{status: "up"}, @content_type)
    |> Conn.halt()

    # case GracefulShutdown.running?() do
    #   true ->
    #     conn
    #     |> send!(:ok, %{status: "up"}, @content_type)
    #     |> Conn.halt()

    #   false ->
    #     conn
    #     |> send!(:service_unavailable, %{status: "down"}, @content_type)
    #     |> Conn.halt()
    # end
  end
end
