defmodule Ev3 do

  def root_path(), do: config(:root_path)

  def load_modules?(), do: config(:load_modules)

  def load_devices?(), do: config(:load_devices)

  def load_display?(), do: config(:load_display)

  defp config(key), do: config()[key]
  defp config(), do: Application.get_env(:scout, :ev3)
end
