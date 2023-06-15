# A ConnectFour class that handles all aspects of playing a game
class ConnectFour

  # Accept board, current_player
  def initialize(board = Array.new(6) { Array.new(7) {0}}, current_player = 1)
    @board = board
    @current_player = current_player
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

    # Define color and symbols for players
    player_colors = {
      1 => "\e[31m",  # Red color
      2 => "\e[33m"   # Yellow color
    }
    player_symbols = {
      1 => "\u26AB",  # Large red circle
      2 => "\u26AA"   # Large white circle
    }

    # Display the board
    puts '  1 2 3 4 5 6 7 '
    puts '-----------------'
    @board.each do |row|
      row_string = row.map do |cell|
        if cell.nil?
          ' '
        else
          "#{player_colors[cell]}#{player_symbols[cell]}\e[0m"
        end
      end.join('|')
      puts "|#{row_string}|"
      puts '-----------------'
    end
  end
end
