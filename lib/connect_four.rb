# A ConnectFour class that handles all aspects of playing a game
class ConnectFour

  # Accept board, current_player
  def initialize
  end

  # Runs a loop that:
  # 1. Accepts and verifies input
  # 2. Updates and displays board
  # 3. Checks for winner
  def play_game
  end

  # An input loop via 'gets'
  def accept_input
  end

  # Makes sure input is a number from 1-7
  def valid_input?(input)
  end

  # Updates board by 'dropping' a piece in a given column
  def drop_piece(col_num)
  end

  # Returns 0, 1, or 2 for no winner or num of winner
  def winner_check
  end

  private

  # Displays board, function generated via AI
  def display_board
  end
end