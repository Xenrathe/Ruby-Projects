require_relative '../lib/connect_four'

module ConnectFourMain
  def self.new_game
    new_game = ConnectFour.new
    new_game.play_game
  end
end