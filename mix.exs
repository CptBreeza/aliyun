defmodule Aliyun.Mixfile do
  use Mix.Project

  def project do
    [app: :aliyun,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger, :timex]]
  end

  defp deps do
    [
      {:timex, "~> 3.2"},
      {:logger_file_backend, "~> 0.0.10"},
      {:sweet_xml, "~> 0.6.5"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      {:uuid, "~> 1.1"},
      {:distillery, "~> 1.5", runtime: false}
    ]
  end
end
