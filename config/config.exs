# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :nerves, :firmware,
  fwup_conf: "config/fwup.conf",
  rootfs_additions: "config/rootfs-additions"

# if unset, the default regulatory domain is the world domain, "00"
config :nerves_interim_wifi,
  regulatory_domain: "US"

config :ev3,
  base_path: "/sys/class",
  boot_devices: true

# Change this to your WiFi module's driver name.
# Examples are:
#    "mt7601u" for a MediaTek MT7601u (Tenda WM311MI)
#    "rt2800usb" for Ralink RT53xx-based modules
#
# An easy way to figure out which driver is needed for
# your WiFi module is to do the following:
#
# 1. Go to a Linux computer (A Raspberry Pi works)
# 2. Run `lsmod > before` without the module plugged in
# 3. Plug it in
# 4. Run `lsmod > after`
# 5. Run `diff before after`
#
# You might get multiple entries, but look for one of the
# above driver names. If you don't see one of these, you'll
# need to build a custom Nerves system image with the
# correct driver module enabled.
config :scout,
  wifi_driver: "mt7601u"
  #wifi_driver: "rt2800usb"

import_config "secrets.exs"
# config :scout, :wlan0,
#   ssid: "my_access_point",
#   key_mgmt: :"WPA-PSK",
#   psk: "secretsecret"
