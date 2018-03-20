defmodule Aliyun.Mixfile do
  use Mix.Project

  def project do
    [app: :aliyun,
     version: "0.1.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [
      extra_applications: [:logger, :logger_file_backend, :timex]
    ]
  end

  defp deps do
    [
      {:timex, "~> 3.2"},
      {:logger_file_backend, "~> 0.0.10"},
      {:sweet_xml, "~> 0.6.5"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      {:uuid, "~> 1.1"},
      {:distillery, "~> 1.5", runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    "阿里云对象存储OSS与短信服务接口库"
  end

  defp package do
    [
      files: ["lib", "config", "priv", "mix.exs", "README.md"],
      maintainers: ["linq <linq.lin@qq.com>"],
      licenses: ["MIT"],
      links: %{"GitHub": "https://github.com/wzdot/aliyun.git"}
    ]    
  end
end
