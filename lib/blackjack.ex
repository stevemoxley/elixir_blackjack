defmodule Blackjack do

  def start do
    #Entry point for the game

    #Create a dealer and a player
    dealer = create_player(:dealer, 1000)
    player = create_player(:human, 1000)

    #Show the starting welcome message
    IO.puts("Welcome to Blackjack!")

    #start the first game
    play_new_hand(dealer, player)

    true
  end

  def play_new_hand(dealer, player) do
    #deal the dealer cards
    dealer = %{dealer | cards: get_starting_cards() }

    #deal the player cards
    player = %{player | cards: get_starting_cards() }

    #prompt the player and start the bidding loop
    show_cards_and_prompt_for_decision(dealer, player)
  end

  def show_cards_and_prompt_for_decision(dealer, player) do
    #Show what the dealer is showing
    IO.puts("Dealer cards: *" <> Enum.join(Enum.slice(dealer.cards, 1, Enum.count(dealer.cards) - 1)))

    #Show what the player is showing and their total
    IO.puts("Player cards: " <> Enum.join(player.cards, " "))
    player_total = get_hand_total(player.cards)
    IO.puts("Total: " <> to_string(player_total))
    cond do
      #1) Do we have blackjack and the dealer doesnt
      !has_blackjack(dealer.cards) && has_blackjack(player.cards) ->
        IO.puts("Blackjack")
      #2) Did we bust?
      player_total > 21 ->
        IO.puts("Bust")
      #3) None of the above just continue to player decision phase
      true ->
        #Ask the player what they want to do
        decision = IO.gets("What would you like to do? (H)it (S)tay :\n")
        |> String.downcase()
        |> String.trim()
        case decision do
          "h" ->
          #If they Hit. Add another card to their hand and prompt again for decision
          IO.puts("Hit")
          player = player |> hit()
          show_cards_and_prompt_for_decision(dealer, player)
          "s" ->
          #If they stay. Play for the dealer and figure the outcome
          IO.puts("Stay")
          play_dealer(dealer, player)
          _ ->
          IO.puts("Please select a valid option.")
          show_cards_and_prompt_for_decision(dealer, player)
        end
    end
  end

  def play_dealer(dealer, player) do
    #The AI must either bust or hit 17 or above
    dealer_total = dealer.cards |> get_hand_total()

    if (dealer_total < 17) do
      #Hit
      dealer = dealer |> hit()
      #Keep playing the dealer until we hit 17 or above or bust
      play_dealer(dealer, player)
    else
      #stay
      player_total = player.cards |> get_hand_total()

      cond do
        player_total > dealer_total ->
          #win
          IO.puts("Player wins")
        player_total < dealer_total ->
          #lose
          IO.puts("Player loses")
        player_total == dealer_total ->
          #push
          IO.puts("Push")
      end
    end
  end


  def has_blackjack(cards) do
    has_ace = Enum.member?(cards, "A")
    has_10 = Enum.member?(cards, "K") ||
            Enum.member?(cards, "Q") ||
            Enum.member?(cards, "J") ||
            Enum.member?(cards, 10)

    has_ace && has_10 && Enum.count(cards) == 2
  end

  def get_hand_total(cards) do
    number_of_aces = Enum.count(cards, &(&1 == "A")) #Count the number of aces
    standard_cards_value = Enum.reduce(cards, 0, &(get_standard_card_value(&1) + &2))
    aces_value = get_aces_value(standard_cards_value, number_of_aces)
    standard_cards_value + aces_value
  end

  def hit(player) do
    %{player | cards: player.cards ++ [get_card()]}
  end

  def get_aces_value(standard_cards_value, number_of_aces) do
    if number_of_aces > 0 do
      first_ace_value = if standard_cards_value + 11 > 21, do: 1, else: 11
      additional_aces_value = if number_of_aces > 1, do: number_of_aces - 1, else: 0
      first_ace_value + additional_aces_value
    else
      0
    end
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

  def create_player(type, starting_money) do
     %{type: type, money: starting_money, cards: []}
  end

  def get_starting_cards() do
    [get_card(), get_card()]
  end

  def get_card() do
    deck = ["A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2]
    random = :rand.uniform(Enum.count(deck)) - 1
    Enum.at(deck, random)
  end
end
