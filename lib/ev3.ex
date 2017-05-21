defmodule Ev3 do
  def root_path do
    config()[:base_path]
  end

  def config do
    Application.get_env(:drone, :ev3)
  end
end
