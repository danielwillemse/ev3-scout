defmodule Ev3.Device do
  defmodule InvalidCommandError do
    defexception message: "Invalid command for ev3 device"
  end

  def connected_devices(type) do
    type
    |> Ev3.Util.ls()
    |> Enum.filter(fn(name) ->
      Ev3.Util.device?(type, name)
    end)
  end

  def connected?(type, name) do
    connected_devices(type)
    |> Enum.any?(fn(f) -> f == name end)
  end
end
