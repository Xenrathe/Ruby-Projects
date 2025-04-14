# A ConnectFour class that handles all aspects of playing a game
class ConnectFour

  # Accept board, current_player
  def initialize(board = Array.new(6) { Array.new(7) { 0 } }, current_player = 1)
    @board = board
    @current_player = current_player
  end

  # Runs a loop that:
  # 1. Accepts and verifies input
  # 2. Updates and displays board
  # 3. Checks for winner
  def play_game
    puts 'Welcome to Connect-Four! New game initialized!'

    while winner_check.zero?
      display_board
      puts "Player #{@current_player}, input column [1 2 3 4 5 6 7] to drop token into>>"
      drop_piece(accept_input)
      @current_player = @current_player == 1 ? 2 : 1
    end

    display_board
    winner = winner_check
    if winner == -1
      puts "It was a draw!\n\n"
    else
      puts "Congratulations player #{winner}! You won!\n\n"
    end

    loop do
      puts 'Would you like to play another game? Y/N?>>'
      input_str = gets.chomp.downcase
      if input_str == 'y'
        @current_player = 1
        @board = Array.new(6) { Array.new(7) { 0 } }
        play_game
        break
      elsif input_str == 'n'
        break
      end
    end
  end

  # An input loop via 'gets'
  def accept_input
    loop do
      input_string = gets.chomp

      if input_string.length != 1
        puts 'Error: Please input a number from 1 to 7>>'
        next
      end

      next unless valid_input?(input_string)

      return input_string.to_i
    end
  end

  # Makes sure input is a number from 1-7
  def valid_input?(input)
    if input.to_i < 1 || input.to_i > 7
      puts 'Error: Please input a number greater than 0 but less than 8>>'
      nil
    elsif @board[0][input.to_i - 1] != 0
      puts 'Error: Column is full! Drop into a non-full column>>'
      nil
    else
      input
    end
  end

  # Updates board by 'dropping' a piece in a given column
  # Other functions will prevent dropping into a full column, so no need to check
  def drop_piece(col_num)
    # Count bottom up until you hit the first in the given column
    @board.reverse_each do |row|
      if row[col_num - 1].zero?
        row[col_num - 1] = @current_player
        break
      end
    end
  end

  # Returns 0, 1, or 2 for no winner or num of winner
  def winner_check
    # Check horizontally
    @board.each do |row|
      row.each_cons(4) do |slice|
        return slice[0] if slice.uniq.length == 1 && !slice[0].zero?
      end
    end

    # Check vertically
    @board.transpose.each do |row|
      row.each_cons(4) do |slice|
        return slice[0] if slice.uniq.length == 1 && !slice[0].zero?
      end
    end

    # Check diagonally
    (0..2).each do |row|
      # top-left to bottom-right
      (0..3).each do |column|
        slice = [@board[row][column], @board[row + 1][column + 1], @board[row + 2][column + 2], @board[row + 3][column + 3]]
        return slice[0] if slice.uniq.length == 1 && !slice[0].zero?
      end

      # top-right to bottom-left
      (3..6).each do |column|
        slice = [@board[row][column], @board[row + 1][column - 1], @board[row + 2][column - 2], @board[row + 3][column - 3]]
        return slice[0] if slice.uniq.length == 1 && !slice[0].zero?
      end
    end

    # Check if the board is completely full, but no winner
    return -1 if @board.flatten.none?(&:zero?)

    # No winner found but moves remain
    0
  end

  private

  # Displays board, function generated via AI
  def display_board

    # Define color and symbols for players
    red = "\e[38;2;255;0;0m"
    yellow = "\e[1m\e[33m"
    blue = "\e[1m\e[34m"
    reset = "\e[0m"

    player_colors = {
      1 => red, # Red color
      2 => yellow # Yellow color
    }
    player_symbol = "\u2638" # Snowflake symbol - solid circle has spacing issues

    # Display the board
    puts "\n   1 2 3 4 5 6 7 "
    puts "  #{blue}---------------#{reset}"
    @board.each do |row|
      row_string = row.map do |cell|
        if cell.zero?
          ' '
        else
          "#{player_colors[cell]}#{player_symbol}#{reset}"
        end
      end.join("#{blue}|#{reset}")
      puts "  #{blue}|#{reset}#{row_string}#{blue}|#{reset}"
      puts "  #{blue}---------------#{reset}"
    end
    puts "\n\n"
  end
end
