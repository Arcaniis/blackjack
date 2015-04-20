def system_clear
  system('cls')
  system('clear')
end

system_clear

def say(msg)
  puts ""
  puts "=> #{msg}"
end

def initialize_deck
  single_deck = ['|2C|', '|3C|', '|4C|', '|5C|', '|6C|', '|7C|', '|8C|', '|9C|',
                '|10C|', '|JC|', '|QC|', '|KC|', '|AC|', '|2D|', '|3D|', '|4D|',
                '|5D|', '|6D|', '|7D|', '|8D|', '|9D|', '|10D|', '|JD|', '|QD|',
                '|KD|', '|AD|', '|2S|', '|3S|', '|4S|', '|5S|', '|6S|', '|7S|',
                '|8S|', '|9S|', '|10S|', '|JS|', '|QS|', '|KS|', '|AS|', '|2H|',
                '|3H|', '|4H|', '|5H|', '|6H|', '|7H|', '|8H|', '|9H|', '|10H|',
                '|JH|', '|QH|', '|KH|', '|AH|',]

  game_deck = single_deck * 6
end

def update_screen(money, bet, dealer_hand, dealer_value, player_hand, player_value, value_table, players_turn)
  if players_turn
    system_clear
    say("Your balance is: $#{money - bet}")
    say("Your bet is: $#{bet}")

    say("Dealer shows: 'HIDDEN' / #{dealer_hand[1]}")
    display_hand('Player', hand_value(player_hand, value_table), player_hand)
  else
    system_clear
    say("Your balance is: $#{money - bet}")
    say("Your bet is: $#{bet}")

    display_hand('Dealer', hand_value(dealer_hand, value_table), dealer_hand)
    display_hand('Player', hand_value(player_hand, value_table), player_hand)
  end
end

def deal_cards(game_deck, dealer_hand, player_hand)
  2.times do
    card_dealt = rand(game_deck.count)
    dealer_hand << game_deck[card_dealt]
    game_deck.delete_at(card_dealt)
  end

  2.times do
    card_dealt = rand(game_deck.count)
    player_hand << game_deck[card_dealt]
    game_deck.delete_at(card_dealt)
  end
end

def hand_value(hand, value_table)
  value = 0
  hand.each do |card|
    value += value_table[card]
  end
  value
end

def display_hand(name, hand_value, hand)
  say("#{name} shows #{hand_value}: #{hand.join(" ")}")
end

def hit?
  begin
    say("Would you like to hit? (Y/N)")
    hit = gets.chomp.to_s.downcase
  end until hit == 'y' || hit == 'n'
  hit
end

def take_hit(game_deck, hand)
  card_dealt = rand(game_deck.count)
  hand << game_deck[card_dealt]
  game_deck.delete_at(card_dealt)
end

def modify_ace_value(hand, value)
  hand_value = value
  hand.each do |card|
    if hand_value > 21
      if card =~ /\|A.\|/
        card.gsub!(/[A]/, '-A' )
        hand_value -= 10
      end
    end
  end
end

def modify_money(money, bet, outcome)
  if outcome == 'W'
    money += bet
  elsif outcome == 'L'
    money -= bet
  else
    money += (bet * 3) / 2 
  end
  money
end

def check_shoe(game_deck)
  game_deck.count < 48
end

def play_again?(dealer_hand, player_hand)
  dealer_hand.clear
  player_hand.clear
  play_again = nil
  while play_again != 'y' && play_again != 'n'
    say("Would you like to play again? (Y/N)")
    play_again = gets.chomp.downcase
  end
  play_again
end

dealer_hand = []
player_hand = []
value_table = {'|2C|' => 2, '|3C|' => 3, '|4C|' => 4, '|5C|' => 5, '|6C|' => 6,
              '|7C|' => 7, '|8C|' => 8, '|9C|' => 9, '|10C|' => 10,
              '|JC|' => 10, '|QC|' => 10, '|KC|' => 10, '|AC|' => 11,
              '|-AC|' => 1, '|2D|' => 2, '|3D|' => 3, '|4D|' => 4, '|5D|' => 5,
              '|6D|' => 6, '|7D|' => 7, '|8D|' => 8, '|9D|' => 9, '|10D|' => 10,
              '|JD|' => 10, '|QD|' => 10, '|KD|' => 10, '|AD|' => 11, '|-AD|' => 1,
              '|2S|' => 2, '|3S|' => 3, '|4S|' => 4, '|5S|' => 5, '|6S|' => 6,
              '|7S|' => 7, '|8S|' => 8, '|9S|' => 9, '|10S|' => 10, '|JS|' => 10,
              '|QS|' => 10, '|KS|' => 10, '|AS|' => 11, '|-AS|' => 1, '|2H|' => 2,
              '|3H|' => 3, '|4H|' => 4, '|5H|' => 5, '|6H|' => 6, '|7H|' => 7,
              '|8H|' => 8, '|9H|' => 9, '|10H|' => 10, '|JH|' => 10, '|QH|' => 10,
              '|KH|' => 10, '|AH|' => 11, '|-AH|' => 1}

game_deck = initialize_deck

puts "=> Please enter how much money you will be changing to chips: (EX: $500 = '500'"
puts "** Minimum bets are $20 **"
money = gets.to_i

system_clear

begin
  dealer_hand = []
  player_hand = []
  player_blackjack = false
  dealer_blackjack = false
  player_bust = false
  dealer_bust = false
  bet = money * 2

  system_clear

  while (bet > money || bet < 20)
    say("Your balance is: $#{money}")
    say("How much would you like to bet this game? (Min: 20)")
    bet = gets.to_i
    system_clear
  end

  system_clear

  say("Your balance is: $#{money - bet}")
  say("Your bet is: $#{bet}")

  deal_cards(game_deck, dealer_hand, player_hand)

  say("Dealer shows: 'HIDDEN' / #{dealer_hand[1]}")
  display_hand('Player', hand_value(player_hand, value_table), player_hand)

  if hand_value(player_hand, value_table) == 21
    say("You got BlackJack! You win!")
    player_blackjack = true
    money = modify_money(money, bet, 'B')
  else
    while hit? == 'y'
      take_hit(game_deck, player_hand)
      hand_value(player_hand, value_table) > 21 ? player_bust = true : player_bust = false
      if player_bust
        modify_ace_value(player_hand, hand_value(player_hand, value_table))
      end
      update_screen(money, bet, dealer_hand, hand_value(dealer_hand, value_table), player_hand, hand_value(player_hand, value_table), value_table, true)
      hand_value(player_hand, value_table) > 21 ? player_bust = true : player_bust = false
      if player_bust
        sleep(1)
        say("BUST!")
        say("Dealer wins!")
        money = modify_money(money, bet, 'L')
        break
      end
      if hand_value(player_hand, value_table) == 21
        sleep(1)
        say("You hit 21!")
        break
      end
    end
  end

  if !player_bust && !player_blackjack
    update_screen(money, bet, dealer_hand, hand_value(dealer_hand, value_table), player_hand, hand_value(player_hand, value_table), value_table, false)
    sleep(1)
    if hand_value(dealer_hand, value_table) == 21
      say("Dealer has BlackJack. You lose :(")
        dealer_blackjack = true
      money = modify_money(money, bet, 'L')
    else
      while hand_value(dealer_hand, value_table) < 17
        say("Dealer hits")
        sleep(1)
        take_hit(game_deck, dealer_hand)
        hand_value(dealer_hand, value_table) > 21 ? dealer_bust = true : dealer_bust = false
        if dealer_bust
          modify_ace_value(dealer_hand,hand_value(dealer_hand, value_table))
        end
        update_screen(money, bet, dealer_hand, hand_value(dealer_hand, value_table), player_hand, hand_value(player_hand, value_table), value_table, false)
        hand_value(dealer_hand, value_table) > 21 ? dealer_bust = true : dealer_bust = false
        if dealer_bust
          sleep(1)
          say("Dealer BUSTS!")
          say("You Win!")
          money = modify_money(money, bet, 'W')
          break
        end
        if hand_value(dealer_hand, value_table) == 21
          say("Dealer hit 21!.")
          break
        end
      end
    end
  end

  if (!player_bust && !dealer_bust) && (!player_blackjack && !dealer_blackjack)
    if hand_value(player_hand, value_table) > hand_value(dealer_hand, value_table)
      sleep(1)
      say("You Win!")
      money = modify_money(money, bet, 'W')
    elsif hand_value(dealer_hand, value_table) > hand_value(player_hand, value_table)
      sleep(1)
      say("Dealer wins!")
      money = modify_money(money, bet, 'L')
    else
      sleep(1)
      say("Push...")
    end
  end

  if check_shoe(game_deck)
    game_deck = initialize_deck
  end

  if money < 20
    sleep(1.5)
    say("You do not have enough money to continue playing :(")
    say("Goodbye and thanks for playing.")
    game_over = true
  end
end until game_over == true || play_again?(dealer_hand, player_hand) == 'n'
