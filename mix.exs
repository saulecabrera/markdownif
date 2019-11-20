defmodule Markdownif.MixProject do
  use Mix.Project

  def project do
    [
      app: :markdownif,
      version: "0.9.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      compilers: [:rustler] ++ Mix.compilers,
      rustler_crates: crates(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler, "~> 0.21.0"},
      {:benchee, "~> 1.0", only: :dev},
    ]
  end

  defp crates do
    [
      markdownif: [
        path: "native/markdownif",
        features: [],
      ]
    ]
  end
end
