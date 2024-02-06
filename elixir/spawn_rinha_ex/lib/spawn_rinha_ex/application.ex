defmodule SpawnRinhaEx.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        SpawnSdk.System.Supervisor,
        system: "spawn-rinha",
        actors: [
          SpawnRinhaEx.Actors.Account
        ]
      }
    ]

    opts = [strategy: :one_for_one, name: SpawnRinhaEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
