defmodule XMLMapper.Mixfile do
  use Mix.Project

  def project do
    [app: :xml_mapper,
     version: "1.0.0",
     elixir: ">= 1.3.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:erlsom, git: "https://github.com/willemdj/erlsom.git", ref: "833fa057d199e0c9dc0232d560d2f742c57476b0"}]
  end

  defp description do
    """
      A simple XML mapper for Elixir.
    """
  end

  defp package do
    [
      maintainers: ["belloq"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/belloq/xml_mapper"},
      files: ~w(mix.exs README.md lib)
    ]
  end
end
