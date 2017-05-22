use Mix.Config

config :scout, :ev3,
  root_path: "test/support/ev3/sys/class",
  load_modules: false,
  load_display: false,
  load_devices: false
