defmodule FoodStandTest do
  use ExUnit.Case
  doctest FoodStand

  test "greets the world" do
    assert FoodStand.hello() == :world
  end
end
