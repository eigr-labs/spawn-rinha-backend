defmodule SpawnRinhaEx.Application do
  @moduledoc false
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {
        SpawnSdk.System.Supervisor,
        system: "spawn-rinha",
        actors: [
          SpawnRinhaEx.Actors.Account
        ]
      },
      {Bandit, get_bandit_options()}
    ]

    opts = [strategy: :one_for_one, name: SpawnRinhaEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def prep_stop(_args) do
    Logger.info("[Spawn Rinha Backend] Application stopping...")
  end

  @impl true
  def stop(_args) do
    Logger.info("[Spawn Rinha Backend] Application stopped!")
  end

  defp get_bandit_options() do
    [
      plug: SpawnRinhaEx.Api.Router,
      port: 9090,
      scheme: :http,
      thousand_island_options: [
        max_connections_retry_wait: 2000,
        max_connections_retry_count: 10,
        num_acceptors: 150,
        shutdown_timeout: 30_000
      ]
    ]
  end
end
