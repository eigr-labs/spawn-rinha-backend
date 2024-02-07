defmodule SpawnRinhaEx.MixProject do
  use Mix.Project

  @app :spawn_rinha_ex
  @version "0.1.0"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {SpawnRinhaEx.Application, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.1"},
      {:spawn_sdk, "~> 1.1"},
      {:spawn_statestores_mariadb, "~> 1.1"},
      {:spawn_statestores_postgres, "~> 1.1"}
    ]
  end
end
