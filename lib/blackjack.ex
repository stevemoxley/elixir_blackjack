defmodule Blackjack do

  def start do
    #Entry point for the game

    #Get a dealer and a player
    dealer = get_player(:dealer, 1000)
    player = get_player(:human, 1000)

    #Show the starting welcome message
    IO.puts("Welcome to Blackjack!")

    #start the first game
    deal_new_hand(dealer, player)

    true

  end

  def deal_new_hand(dealer, player) do
    deck = ["A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2]

    #deal the dealer cards
    dealer = %{dealer | cards: get_starting_cards(deck) }

    #deal the player cards
    player = %{player | cards: get_starting_cards(deck) }

    #prompt the player and start the bidding loop
    show_cards_and_prompt_for_decision(dealer, player)

  end

  def show_cards_and_prompt_for_decision(dealer, player) do
    #Show what the dealer is showing


    IO.puts("Player cards:" <> Enum.join(player.cards, " "))
    IO.puts("Total: " <> to_string(get_hand_total(player.cards)))
    IO.puts("What would you like to do? (H)it (S)tay") #Note, there are other options, those can be added later

    #Get the input from the player
    #If they Hit. Add another card to their hand and the dealers hand
    #If they stay. Play for the dealer and figure the outcome
  end

  def get_hand_total(cards) do
    aces = []
    standard_cards_value = Enum.reduce(cards, 0, &(get_standard_card_value(&1) + &2))
    aces_value = Enum.reduce(aces, 0, &(get_ace_card_value(&1) + &2))
    standard_cards_value + aces_value
  end

  def get_standard_card_value(card) do
    case card do
      n when n in 2..10 ->
        card
      "K" ->
        10
      "Q" ->
        10
      "J" ->
        10
      "A" ->
        0 #Ace is calculated in a separate function so just mark zero for now
      _ ->
        raise "No match for this " <> card
    end
  end

  def get_ace_card_value(hand_total) do
    1
  end

  def get_player(type, starting_money) do
     %{type: type, money: starting_money, cards: []}
  end

  def get_starting_cards(deck) do
    [get_card(deck), get_card(deck)]
  end

  def get_card(deck) do
    random = :rand.uniform(Enum.count(deck)) - 1
    Enum.at(deck, random)
  end
end
