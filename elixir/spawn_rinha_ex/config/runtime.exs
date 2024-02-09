import Config

config :logger,
  level: :info

config :mnesia,
  dir:
    to_charlist(
      Path.join(
        File.cwd!(),
        "#{System.get_env("PROXY_DATABASE_DATA_DIR", "data")}/#{to_string(node())}"
      )
    )
