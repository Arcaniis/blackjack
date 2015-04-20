require 'pry'

def system_clear
  system('cls')
  system('clear')
end


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


def take_hit(hand, deck=game_deck)
  card_dealt = rand(deck.count)
  hand << deck[card_dealt]
  deck.delete_at(card_dealt)
end


def modify_ace_value(hand, value)
  hand.each do |card|
    if card =~ /\|A.\|/
      value -= 10
      card.gsub!(/[A]/, '-A' )
      break
    end
  end
end


# Initialize variables
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

# Initialize deck
game_deck = initialize_deck
# gather money info

# take bet

# Deal hands
deal_cards(game_deck, dealer_hand, player_hand)
# Display dealer's hand (w/ hidden) and player's hand. Include value of player.
say("Dealer shows: 'HIDDEN' / #{dealer_hand[1]}")
display_hand('Player', hand_value(player_hand, value_table), player_hand)
# Check for player BlackJack

# Ask player if they want to hit
while hit? == 'y'
  take_hit(player_hand)
  hand_value(player_hand, value_table) > 21 ? player_bust = true : player_bust = false
  if player_bust
    modify_ace_value(player_hand, hand_value(player_hand, value_table))
  end
  display_hand('Player', hand_value(player_hand, value_table), player_hand)
  hand_value(player_hand, value_table) > 21 ? player_bust = true : player_bust = false
  if hand_value(player_hand, value_table) > 21
    puts "BUST!"
    #modify money
    # Play Again?
    break
  end
end
# Check for dealer blackjack

# dealer hits/ or stays

# compare hand values

#determine winner

# modify money

# play again?

