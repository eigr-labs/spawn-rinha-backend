defmodule SpawnRinhaEx.Actors.Account do
  use SpawnSdk.Actor,
    name: "account",
    kind: :unnamed,
    state_type: Io.Eigr.Spawn.Example.MyState

  require Logger
end
