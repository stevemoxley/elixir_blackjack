defmodule BlackjackTest do
  use ExUnit.Case
  doctest Blackjack

  test "start" do
    assert Blackjack.start() == true
  end

end
