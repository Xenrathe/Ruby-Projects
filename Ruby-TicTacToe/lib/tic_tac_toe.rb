# rubocop:disable Metrics/MethodLength

# Creates and plays a game of Tic-Tac-Toe
class TicTacToe
  def initialize(boardstate = Array.new(3) { Array.new(3) { '-' } }, current_player = 'X', game_over = false)
    @boardstate = boardstate
    @current_player = current_player
    @game_over = game_over
  end

  def assess_victory
    # rows
    @boardstate.each do |row|
      return row[0] if row.uniq.length == 1 && row[0] != '-'
    end

    # columns
    @boardstate.transpose.each do |column|
      return column[0] if column.uniq.length == 1 && column[0] != '-'
    end

    # diagonals
    if (@boardstate[0][0] == @boardstate[1][1] && @boardstate[1][1] == @boardstate[2][2]) && @boardstate[0][0] != '-'
      return @boardstate[0][0]
    elsif (@boardstate[0][2] == @boardstate[1][1] && @boardstate[1][1] == @boardstate[2][0]) && @boardstate[0][2] != '-'
      return @boardstate[0][2]
    end

    # no winner yet
    false
  end

  def valid_input?(inputstr)
    num = inputstr.to_i
    if num > 0 && num < 4
      true
    else
      puts 'Error! row and col inputs must be between 1 and 3, inclusive.'
      false
    end
  rescue NoMethodError, ArgumentError, TypeError
    puts 'Error! Input must be of form num,num, integers only.'
    false
  end

  def accept_input
    loop do
      puts "Player #{@current_player}, input move in form row,col, where 1,1 is top-left>>"
      input_string = gets.chomp
      if input_string.length != 3
        puts 'Error! Input must be of form R,C exactly 3 characters long.'
        next
      end

      row = input_string[0]
      col = input_string[2]
      if !valid_input?(row) || !valid_input?(col)
        next
      elsif @boardstate[row.to_i - 1][col.to_i - 1] != '-'
        puts "Error! #{row},#{col} position already taken"
        next
      end

      @boardstate[row.to_i - 1][col.to_i - 1] = @current_player
      break
    end
  end

  def play_game
    loop do
      accept_input
      display_board

      if assess_victory
        puts "Player #{@current_player} is victorious!"
        @game_over = true
      elsif !@boardstate.flatten.include?('-')
        puts 'No moves remain! It was a tie!'
        @game_over = true
      end

      if @game_over
        puts 'Would you like to play again? Y/N>>'
        break unless gets.chomp.downcase == 'y'

        @boardstate = Array.new(3) { Array.new(3) { '-' } }
        @current_player = 'O' #This will flip to 'X'
        display_board
        @game_over = false
      end

      @current_player = @current_player == 'X' ? 'O' : 'X'
    end
  end

  private

  # Prints 'X' and 'O' with some borders around edge
  def display_board
    @boardstate.each do |row|
      print '|'
      row.each do |value|
        print " #{value}"
      end
      puts ' |'
    end
  end

end

# rubocop:enable Metrics/MethodLength
