# frozen_string_literal: true

# this class represents the whole game
class Game
  def initialize
    @board = Array.new(8) { Array.new(8, 0) }

    start = ask_for_start
    finish = ask_for_finish

    @knight = Knight.new(start)

    play_game(finish)
  end
end
