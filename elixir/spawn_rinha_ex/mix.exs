defmodule SpawnRinhaEx.MixProject do
  use Mix.Project

  @app :spawn_rinha_ex
  @version "1.1.1"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
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
      {:bakeware, "~> 0.2"},
      {:spawn_sdk, "~> 1.2"},
      {:spawn_statestores_native, "~> 1.2"}
    ]
  end

  defp releases do
    [
      spawn_rinha_ex: [
        include_executables_for: [:unix],
        applications: [spawn_rinha_ex: :permanent],
        steps: [
          :assemble,
          &Bakeware.assemble/1
        ],
        bakeware: [compression_level: 19]
      ]
    ]
  end
end
