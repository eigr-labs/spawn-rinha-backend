import Config

config :logger,
  level: :error,
  backends: [:console],
  truncate: 65536

config :logger, :console,
  format: "$date $time [$node]:[$metadata]:[$level]:$message\n",
  metadata: [:pid, :span_id, :trace_id]

config :mnesia,
  dir: to_charlist(Path.join(File.cwd!(), "data/#{to_string(node())}"))

config :mnesiac,
  stores: [Statestores.Adapters.Native.SnapshotStore],
  schema_type: :disc_copies,
  table_load_timeout: 600_000

import_config "#{config_env()}.exs"
