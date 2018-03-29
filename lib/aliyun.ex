defmodule Aliyun do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Confex.resolve_env!(:aliyun)
    opts = [strategy: :one_for_one, name: Aliyun.Supervisor]
    Supervisor.start_link([], opts)
  end
end

