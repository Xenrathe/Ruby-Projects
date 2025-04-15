module KnightsTravails
  # Representing a 2d 'chessboard' of custom x_max, y_max size
  class Board
    attr_accessor :x_max, :y_max

    def initialize(x_max, y_max)
      @x_max = x_max
      @y_max = y_max
    end

    def build_moves(start_pos, end_pos)
      # Possible moves of a knight
      moves = [
        [-2, -1], [-2, 1], [-1, -2], [-1, 2],
        [1, -2], [1, 2], [2, -1], [2, 1]
      ]

      untraveled_squares = Array.new(y_max) { Array.new(x_max) { true } }
      queue_of_squares = [Square.new(start_pos[0], start_pos[1], nil)]

      # Do a "level-order" traversal until we arrive at desired location
      loop do
        moves.each do |move|
          y_next = move[1] + queue_of_squares[0].y_pos
          x_next = move[0] + queue_of_squares[0].x_pos
          next unless x_next >= 0 && y_next >= 0 && x_next < @x_max &&
                      y_next < @y_max && untraveled_squares[y_next][x_next]

          new_square = Square.new(x_next, y_next, queue_of_squares[0])
          queue_of_squares.push(new_square)
          untraveled_squares[y_next][x_next] = false
        end

        square = queue_of_squares.shift
        return square if square.x_pos == end_pos[0] && square.y_pos == end_pos[1]
      end
    end

    def knight_moves(start_pos, end_pos)

      if [start_pos, end_pos].flatten.size != 4
        puts 'Error! Invalid start or end pos'
        return nil
      end

      [start_pos, end_pos].each do |pos|
        if pos[0].negative? || pos [1].negative? || pos[0] >= x_max || pos[1] >= y_max
          puts 'Error! Invalid start or end pos.'
          return nil
        end
      end

      current_square = build_moves(start_pos, end_pos)
      move_path = [current_square]

      until current_square.x_pos == start_pos[0] && current_square.y_pos == start_pos[1]
        current_square = current_square.came_from
        move_path.unshift(current_square)
      end

      puts "You made it in #{move_path.size} moves! Here's your path:"
      move_path.each do |square|
        puts "#{square}\n"
      end
    end
  end

  # Represents a square on a 2d chessboard
  class Square
    attr_accessor :x_pos, :y_pos, :came_from

    def initialize(x_pos = 0, y_pos = 0, came_from = nil)
      @x_pos = x_pos
      @y_pos = y_pos
      @came_from = came_from
    end

    def to_s
      "  [#{@x_pos},#{y_pos}]"
    end
  end

  def self.prompt
    puts "Welcome to Knight's Travails!"

    print "\nEnter board size (e.g., 8 for an 8x8 board): "
    size = gets.chomp.to_i
    board = Board.new(size, size)

    print "\nEnter the knight's starting position (e.g., 0,0): "
    start = gets.chomp.split(',').map(&:to_i)

    print "Enter the knight's target position (e.g., 7,7): "
    finish = gets.chomp.split(',').map(&:to_i)

    puts "\nCalculating shortest path from #{start} to #{finish}...\n\n"
    board.knight_moves(start, finish)

    puts "\nTry another? (y/n)"
    retry_input = gets.chomp.strip.downcase
    self.prompt if retry_input == 'y'
  end
end
