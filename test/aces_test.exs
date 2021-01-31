defmodule AcesTest do
  use ExUnit.Case
  doctest Blackjack

  test "test_two_aces" do
    hand = ["A", "A"]
    total = Blackjack.get_hand_total(hand)
    IO.puts("Total:" <> to_string(total))
    assert total == 12
  end

  test "test_three_aces" do
    hand = ["A", "A", "A"]
    total = Blackjack.get_hand_total(hand)
    IO.puts("Total:" <> to_string(total))
    assert total == 13
  end

  test "test_ace_face_card" do
    hand = ["A", "K"]
    total = Blackjack.get_hand_total(hand)
    IO.puts("Total:" <> to_string(total))
    assert total == 21
  end

  test "test_ace_number_card" do
    hand = ["A", 2]
    total = Blackjack.get_hand_total(hand)
    IO.puts("Total:" <> to_string(total))
    assert total == 13
  end

  test "test_ace_number_card_2" do
    hand = ["A", 9]
    total = Blackjack.get_hand_total(hand)
    IO.puts("Total:" <> to_string(total))
    assert total == 20
  end

end
