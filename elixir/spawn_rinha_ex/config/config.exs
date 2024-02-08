import Config

config :logger,
  level: :error,
  backends: [:console],
  truncate: 65536

config :logger, :console,
  format: "$date $time [$node]:[$metadata]:[$level]:$message\n",
  metadata: [:pid, :span_id, :trace_id]

import_config "#{config_env()}.exs"
