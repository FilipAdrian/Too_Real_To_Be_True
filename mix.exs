defmodule CWF.MixProject do
  use Mix.Project

  def project do
    [
      app: :covid_weather_forecast,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CWF.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:castore, "~> 0.1.0"},
      {:mint, "~> 1.0"},
      {:eventsource_ex, "~> 0.0.2"},
      {:jason, "~> 1.1"}
    ]
  end
end
