require_relative '../lib/tic_tac_toe'

describe TicTacToe do

  describe '#assess_victory' do
    context 'when there is no winner' do
      subject(:default_game) { described_class.new }

      it 'returns false' do
        expect(default_game.assess_victory).to eq(false)
      end
    end

    context 'when player O achieves vertical victory' do
      subject(:vert_game) { described_class.new([['O', 'X', 'X'], ['O', '-', 'X'], ['O', 'X', 'O']]) }
      it 'return O' do
        expect(vert_game.assess_victory).to eq('O')
      end
    end

    context 'when player X achieves horizontal victory' do
      subject(:horz_game) { described_class.new([['X', 'X', 'X'], ['O', '-', 'X'], ['O', 'X', 'O']]) }
      it 'returns X' do
        expect(horz_game.assess_victory).to eq('X')
      end
    end

    context 'when player O achieves diagonal victory' do
      subject(:diag_game) { described_class.new([['O', 'X', 'X'], ['-', 'O', 'X'], ['O', 'X', 'O']]) }
      it 'returns O' do
        expect(diag_game.assess_victory).to eq('O')
      end
    end
  end

  describe '#valid_input?' do

    subject(:default_game) { described_class.new }

    context 'when it receives a number between 1-4' do
      it 'returns true' do
        input = '3'
        expect(default_game.valid_input?(input)).to eql(true)
      end
    end

    context 'when it receives a number outside of 1-4' do
      it 'displays an error message' do
        input = '-7'
        expect(default_game).to receive(:puts).with('Error! row and col inputs must be between 1 and 3, inclusive.')
        default_game.valid_input?(input)
      end
    end

    context 'when it receives an input that has no to_i method' do
      # Note: The actual function will catch an error because it's trying to convert a string to an integer
      it 'displays an error message' do
        input = [3, 7]
        expect(default_game).to receive(:puts).with('Error! Input must be of form num,num, integers only.')
        default_game.valid_input?(input)
      end
    end
  end

  describe '#accept_input' do

    subject(:default_game) { described_class.new }

    context 'when it receives a string input not of length 3' do
      it 'sends a prompt, an error message, and re-prompts' do
        valid_input = '1,1'
        long_input = 'apple'
        allow(default_game).to receive(:gets).and_return(long_input, valid_input)

        expect(default_game).to receive(:puts).exactly(3).times
        default_game.accept_input
      end
    end

    context 'when it receives an input of length 3 but not integers' do
      it 'sends a prompt, an error message, and re-prompts' do
        valid_input = '1,1'
        bad_input = 'a,b'
        allow(default_game).to receive(:gets).and_return(bad_input, valid_input)

        expect(default_game).to receive(:puts).exactly(3).times
        default_game.accept_input
      end
    end

    context 'when it receives a valid input for an already taken position' do
      subject(:partial_game) { described_class.new([['O', 'X', 'X'], ['-', '-', '-'], ['-', '-', '-']]) }
      it 'sends a prompt, an error message, and re-prompts' do
        valid_input = '2,2'
        bad_input = '1,2'
        allow(partial_game).to receive(:gets).and_return(bad_input, valid_input)

        expect(partial_game).to receive(:puts).exactly(3).times
        partial_game.accept_input
      end
    end

    context 'when it receives a valid input' do
      it 'correctly alters board-state for X player' do
        input = '1,1'
        allow(default_game).to receive(:gets).and_return(input)

        default_game.accept_input
        expect(default_game.instance_variable_get(:@boardstate)[0][0]).to eq('X')
      end
    end
  end
end
