defmodule Aliyun.Config do
  def get(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
    case Application.get_env(app, key) do
      {:system, var} ->
        case System.get_env(var) do
          nil -> default
          val -> val
        end
      {:system, var, preconfigured_default} ->
        case System.get_env(var) do
          nil -> preconfigured_default
          val -> val
        end
      nil ->
        default
    end
  end
end