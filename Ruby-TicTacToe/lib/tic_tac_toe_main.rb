require_relative '../lib/tic_tac_toe'

module TicTacToeMain

  def self.new_game
    new_game = TicTacToe.new
    new_game.play_game
  end
end
