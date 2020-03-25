defmodule CWFTest do
  use ExUnit.Case
  doctest CWF

  test "greets the world" do
    assert CWF.hello() == :world
  end
end
