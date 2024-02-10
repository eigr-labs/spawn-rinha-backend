defmodule SpawnRinhaEx.Application do
  @moduledoc false
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.configure(level: :error)

    children = [
      {
        SpawnSdk.System.Supervisor,
        system: "spawn-rinha",
        actors: [
          SpawnRinhaEx.Actors.Account
        ]
      },
      %{
        id: :task_create_actors,
        start:
          {Task, :start_link,
           [
             fn ->
               Process.flag(:trap_exit, true)
               Process.sleep(200)

               Enum.each(2..6, fn id ->
                 id = id - 1

                 SpawnSdk.spawn_actor("#{id}",
                   system: "spawn-rinha",
                   actor: "account"
                 )
               end)

               receive do
                 {:EXIT, _pid, _reason} -> :ok
               end
             end
           ]}
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
      port: System.get_env("PROXY_HTTP_PORT") |> String.to_integer(),
      scheme: :http,
      thousand_island_options: [
        max_connections_retry_wait: 10,
        max_connections_retry_count: 100,
        num_acceptors: System.get_env("PROXY_HTTP_ACCEPTORS_SIZE", "200") |> String.to_integer(),
        shutdown_timeout: 30_000
      ]
    ]
  end
end
