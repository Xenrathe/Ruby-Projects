require_relative '../lib/connect_four'

describe ConnectFour do

  describe '#initialize' do
    subject(:default_game) { described_class.new }
    
    context 'when initializing a default game' do
      it 'creates a 2d array with 7 columns, initialized to 0' do
        board = default_game.instance_variable_get(:@board)
        expect(board[6][0]).to eq(0)
      end
    end

    context 'when initializing a default game' do
      it 'creates a 2d array with 6 rows, initialized to 0' do
        board = default_game.instance_variable_get(:@board)
        expect(board[0][5]).to eq(0)
      end
    end
  end

  describe '#accept_input' do

    subject(:default_game) { described_class.new }

    context 'when it receives an input not of length 1' do
      it 'sends an error message' do
        long_input = '12'
        allow(default_game).to receive(:gets).and_return(long_input)

        expect(default_game).to receive(:puts).once.with('Error: Please input a number from 1 to 7.')
        default_game.accept_input
      end
    end

    context 'when it receives an input of length 1' do
      before do
        allow(default_game).to receive(:verify_input?).and_return(nil)
      end

      it 'does not send an error message' do
        valid_input = '7'
        allow(default_game).to receive(:gets).and_return(valid_input)

        expect(default_game).not_to receive(:puts)
        default_game.accept_input
      end
    end
  end

  describe '#valid_input?' do
    subject(:default_game) { described_class.new }

    context 'when it receives a valid input of a number between 1 and 7' do
      it 'does not send an error message' do
        valid_input = '7'

        expect(default_game).not_to receive(:puts)
        default_game.valid_input?(valid_input)
      end
    end

    context 'when it receives a number less than 1' do
      it 'sends an error message' do
        low_input = '0'

        expect(default_game).to receive(:puts).with('Error: Please input a number greater than 0 but less than 8.')
        default_game.valid_input?(low_input)
      end
    end

    context 'when it receives a number greater than 7' do
      it 'sends an error message' do
        high_input = '8'

        expect(default_game).to receive(:puts).with('Error: Please input a number greater than 0 but less than 8.')
        default_game.valid_input?(high_input)
      end
    end

    context 'when it receives a column # that is already full' do
      subject(:full_col_game) { Array.new(6) { Array.new(7) { 1 }}}
      it 'sends an error message' do
        full_input = '7'

        expect(full_col_game).to receive(:puts).with('Error: Column is full! Drop into a non-full column.')
        full_game.valid_input?(full_input)
      end
    end

    context 'when it receives a non-number input' do
      it 'sends an error message' do
        bad_input = 'a'

        expect(default_game).to receive(:puts).with('Error: Please input a number greater than 0 but less than 8.')
        default_game.valid_input?(bad_input)
      end
    end
  end

  describe '#drop_piece' do
    subject(:partially_full_game) { described_class.new(
      [[0, 0, 0, 0, 0, 0, 0],
       [0, 0, 0, 0, 0, 0, 2],
       [0, 0, 0, 0, 0, 2, 1],
       [0, 0, 0, 0, 1, 1, 1],
       [0, 0, 0, 1, 1, 2, 1],
       [0, 1, 0, 1, 2, 1, 2]]) }

    context 'when it receives an empty column input' do
      it 'drops a token to the lowest row' do
        partially_full_game.drop_piece(1)
        board = partially_full_game.instance_variable_get(:@board)
        expect(board[5][0]).to eq(1)
      end
    end

    context 'when it receives an almost full column input' do
      it 'drops a token to the highest row' do
        partially_full_game.drop_piece(7)
        board = partially_full_game.instance_variable_get(:@board)
        expect(board[0][6]).to eq(1)
      end
    end

    context 'when it receives a column input with partially filled column' do
      it 'drops a token to the row above the current height' do
        partially_full_game.drop_piece(4)
        board = partially_full_game.instance_variable_get(:@board)
        expect(board[3][3]).to eq(1)
      end
    end

    context 'when it receives a column input during player 2' do
      subject(:second_player_game) { described_class.new(
        [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 2],
         [0, 0, 0, 0, 0, 2, 1],
         [0, 0, 0, 0, 1, 1, 1],
         [0, 0, 0, 1, 1, 2, 1],
         [0, 1, 0, 1, 2, 1, 2]], 2) }

      it 'drops a player 2 token to the bottom' do
        second_player_game.drop_piece(1)
        board = second_player_game.instance_variable_get(:@board)
        expect(board[5][0]).to eq(2)
      end
    end
  end

  describe '#winner_check' do
    context 'when there is no winner' do
      subject(:no_winner_game) { described_class.new(
        [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 2],
         [0, 0, 0, 0, 0, 2, 1],
         [0, 0, 0, 0, 1, 1, 1],
         [0, 0, 0, 1, 1, 2, 1],
         [0, 1, 0, 1, 2, 1, 2]]) }

      it 'returns a 0' do
        expect(no_winner_game.winner_check).to eq(0)
      end
    end

    context 'when player 1 has a column win' do
      subject(:column_win_game) { described_class.new(
        [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 1],
         [0, 0, 0, 0, 0, 2, 1],
         [0, 0, 0, 0, 1, 1, 1],
         [0, 0, 0, 1, 1, 2, 1],
         [0, 1, 0, 1, 2, 1, 2]]) }

      it 'returns a 1' do
        expect(column_win_game.winner_check).to eq(1)
      end
    end

    context 'when player 2 has a row win' do
      subject(:row_win_game) { described_class.new(
        [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 2],
         [0, 0, 0, 0, 0, 2, 1],
         [0, 0, 0, 0, 1, 1, 2],
         [0, 0, 0, 1, 1, 2, 1],
         [0, 1, 2, 2, 2, 2, 1]]) }

      it 'returns a 2' do
        expect(row_win_game.winner_check).to eq(2)
      end
    end

    context 'when player 1 has a positive slope diagonal win' do
      subject(:posdiag_win_game) { described_class.new(
        [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 2],
         [0, 0, 0, 0, 0, 2, 1],
         [0, 0, 0, 0, 1, 1, 2],
         [0, 0, 0, 0, 1, 2, 1],
         [0, 1, 2, 1, 2, 2, 1]]) }

      it 'returns a 1' do
        expect(posdiag_win_game.winner_check).to eq(1)
      end
    end

    context 'when player 2 has a negative slope diagonal win' do
      subject(:posdiag_win_game) { described_class.new(
        [[2, 0, 0, 0, 0, 0, 0],
         [1, 2, 0, 0, 0, 0, 2],
         [2, 1, 2, 0, 0, 2, 1],
         [1, 2, 1, 2, 1, 1, 2],
         [2, 2, 1, 2, 1, 2, 1],
         [1, 1, 2, 2, 1, 2, 1]]) }

      it 'returns a 2' do
        expect(posdiag_win_game.winner_check).to eq(2)
      end
    end

    context 'when the board is totally full with no winner' do
      subject(:posdiag_win_game) { described_class.new(
        [[1, 2, 1, 2, 1, 2, 1],
         [2, 1, 2, 1, 2, 1, 2],
         [1, 2, 1, 2, 1, 2, 1],
         [2, 1, 2, 1, 2, 1, 2],
         [1, 2, 1, 2, 1, 2, 1],
         [2, 1, 2, 1, 2, 1, 2]]) }

      it 'returns a -1' do
        expect(posdiag_win_game.winner_check).to eq(-1)
      end
    end
  end
end
