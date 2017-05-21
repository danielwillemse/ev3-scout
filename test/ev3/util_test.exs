defmodule Ev3.UtilTest do
  use ExUnit.Case

  test "it writes the device value" do
    Ev3.Util.write!("tacho-motor", "motor0", "driver_name", "some-motor")

    assert "some-motor" = File.read!(Ev3.root_path() <> "/tacho-motor/motor0/driver_name")
  end

  test "it reads the device value" do
    File.write!(Ev3.root_path() <> "/tacho-motor/motor0/driver_name", "some-motor")

    assert "some-motor" = Ev3.Util.read!("tacho-motor", "motor0", "driver_name")
  end

  test "device? returns false for non-devices" do
    File.write!(Ev3.root_path() <> "/tacho-motor/.DS_Store", "some random value")
    refute Ev3.Util.device?("tacho-motor", ".DS_Store")
  end

  test "device? returns true for devices" do
    Ev3.Util.write!("tacho-motor", "motor0", "driver_name", "some-motor")
    assert Ev3.Util.device?("tacho-motor", "motor0")
  end
end
