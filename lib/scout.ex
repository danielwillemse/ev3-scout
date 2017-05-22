defmodule NervesEv3Example do
  use Application
  import Supervisor.Spec

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    if Ev3.load_modules? do
      load_ev3!()
      spawn fn -> System.cmd("espeak", ["Scout reporting for duty"]) end
    end

    children = [] |> add_device_workers() |> add_display_workers()

    opts = [strategy: :one_for_one, name: NervesEv3Example.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def add_device_workers(children) do
    if Ev3.load_devices?() do
      [supervisor(Ev3.DeviceSupervisor, [strategy: :one_for_one]) | children]
    else
      children
    end
  end

  def add_display_workers(children) do
    if Ev3.load_display? do
      [worker(NervesEv3Example.Display, []) | children]
    else
      children
    end
  end

  defp load_ev3!() do
    load_ev3_modules()
    start_writable_fs()
    start_wifi()
  end

  defp load_ev3_modules() do
    wifi_driver = Application.get_env(:scout, :wifi_driver)
    System.cmd("modprobe", [wifi_driver])

    System.cmd("/sbin/udevd", ["--daemon"])
    Process.sleep(1000)  # I do not like this line

    System.cmd("modprobe", ["suart_emu"])

    # Port 1 may be disabled -> see rootfs-additions/etc/modprobe.d
    System.cmd("modprobe", ["legoev3_ports"])
    System.cmd("modprobe", ["snd_legoev3"])
    System.cmd("modprobe", ["legoev3_battery"])
    System.cmd("modprobe", ["ev3_uart_sensor_ld"])

    # Initialize ALSA so that you can use espeak and aplay
    System.cmd("alsactl", ["restore"])
  end

  defp start_wifi() do
    opts = Application.get_env(:scout, :wlan0)
    Nerves.InterimWiFi.setup "wlan0", opts
  end

  defp redirect_logging() do
    Logger.add_backend {LoggerFileBackend, :error}
    Logger.configure_backend {LoggerFileBackend, :error},
      path: "/mnt/system.log",
      level: :info
    Logger.remove_backend :console

    # Turn off kernel logging to the console
    #System.cmd("dmesg", ["-n", "1"])
  end

  defp format_appdata() do
    case System.cmd("mke2fs", ["-t", "ext4", "-L", "APPDATA", "/dev/mmcblk0p3"]) do
      {_, 0} -> :ok
      _ -> :error
    end
  end

  defp maybe_mount_appdata() do
    if !File.exists?("/mnt/.initialized") do
      mount_appdata()
    else
      :ok
    end
  end

  defp mount_appdata() do
    case System.cmd("mount", ["-t", "ext4", "/dev/mmcblk0p3", "/mnt"]) do
      {_, 0} ->
          File.write("/mnt/.initialized", "Done!")
          :ok
      _ ->
          :error
    end
  end

  defp start_writable_fs() do
    case maybe_mount_appdata() do
      :ok ->
        redirect_logging()
      :error ->
        case format_appdata() do
          :ok ->
            mount_appdata()
            redirect_logging()
          error -> error
        end
    end
  end

end
