defmodule Markdownif.MixProject do
  use Mix.Project

  @version "0.9.0"

  def project do
    [
      app: :markdownif,
      name: "Markdownif",
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: crates(),
      deps: deps(),
      package: package(),
      description: description()
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
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp crates do
    [
      markdownif: [
        path: "native/markdownif",
        features: []
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Saúl Cabrera <saulecabrera@gmail.com>"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/saulecabrera/markdownif"}
    ]
  end

  defp description do
    "Markdown NIFs built on top of pulldown-cmark using Rustler"
  end
end
