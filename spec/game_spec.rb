# frozen_string_literal: true
require_relative '../lib/game'
require_relative '../lib/knight'
require_relative '../lib/tree_node'

describe Game do
  subject(:game) { described_class.new }
  before do
    allow(Knight).to receive(:new)
    game.instance_variable_set(:@knight, double(Knight))
  end

  describe '#initialize' do
    context 'when called' do
      it 'calls ::new on Knight' do
        expect(Knight).to receive(:new)
        described_class.new
      end
    end
  end

  describe '#start' do
    let(:knight) { game.instance_variable_get(:@knight)}
    before do
      allow(game).to receive(:user_input).and_return([0, 0], [1, 2])
      allow(game).to receive(:play_game)
    end

    context 'when called' do
      it 'calls #create_tree_root on a Knight object' do
        allow(knight).to receive(:create_tree_root)
        expect(knight).to receive(:create_tree_root)
        game.start
      end
    end
  end

  describe '#user_input' do
    context 'when asking for the starting position' do
      let(:time) { 'start' }
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:puts).with('Invalid position, try again!')
      end

      context 'when user enters a valid input the first time' do
        before do
          allow(game).to receive(:gets).and_return('0,0', '0,0')
          allow(game).to receive(:valid_input?).with(['0', '0']).and_return(true, true)
        end

        it 'exits the loop at the first iteration' do
          expect(game).to receive(:puts).once
          game.user_input(time)
        end

        it 'returns an array of integers' do
          return_value = game.user_input(time)
          expect(return_value).to eq([0, 0])
        end
      end

      context 'when user enters an invalid input and then a valid input' do
        before do
          allow(game).to receive(:gets).and_return('a,2', '0,0')
          allow(game).to receive(:valid_input?).and_return(false, true)
        end

        it 'exits the loop at the second iteration' do
          expect(game).to receive(:puts).with('Invalid position, try again!').once
          game.user_input(time)
        end

        it 'returns an array of integers' do
          return_value = game.user_input(time)
          expect(return_value).to eq([0,0])
        end
      end

      context 'when user enters an invalid input twice and then a valid input' do
        before do
          allow(game).to receive(:gets).and_return('a,2', '-1,2', '1,1')
          allow(game).to receive(:puts).with('Invalid position, try again!')
        end

        it 'exits the loop at the third iteration' do
          expect(game).to receive(:puts).with('Invalid position, try again!').twice
          game.user_input(time)
        end

        it 'returns an array of integers' do
          return_value = game.user_input(time)
          expect(return_value).to eq([1,1])
        end
      end
    end
  end

  describe '#input_valid?' do
    context 'when given two numbers digits' do
      it 'is valid' do
        input = %w[0 0]
        expect(game).to be_valid_input(input)
      end

      it 'is valid' do
        input = %w[7 7]
        expect(game).to be_valid_input(input)
      end

      it 'is valid' do
        input = %w[3 2]
        expect(game).to be_valid_input(input)
      end
    end

    context 'when given an invalid input' do
      context 'when given letters' do
        it 'is not valid input' do
          input = ['a', '2']
          expect(game).not_to be_valid_input(input)
        end

        it 'is not valid input' do
          input = ['a', 'b']
          expect(game).not_to be_valid_input(input)
        end
      end

      context 'when given invalid numbers' do
        context 'when given negative numbers' do
          it 'is not valid input' do
            input = %w[-2 1]
            expect(game).not_to be_valid_input(input)
          end
        end

        context 'when given out of range numbers' do
          it 'is not valid input' do
            input = %w[0 9]
            expect(game).not_to be_valid_input(input)
          end

          it 'is not valid input' do
            input = %w[9 10]
            expect(game).not_to be_valid_input(input)
          end
        end
      end

      context 'when given more than two digits' do
        context 'when they are numbers' do
          it 'is not valid input' do
            input = %w[1 2 3]
            expect(game).not_to be_valid_input(input)
          end
        end

        context 'when they are letters' do
          it 'is not valid input' do
            input = %w[a b c]
            expect(game).not_to be_valid_input(input)
          end
        end
      end

      context 'when given nothing' do
        it 'is not valid input' do
          input = []
          expect(game).not_to be_valid_input(input)
        end
      end
    end
  end

  describe '#create_position_tree' do
    let(:knight) { game.instance_variable_get(:@knight) }
    before do
      allow(game).to receive(:add_nodes_to_tree)
      allow(knight).to receive(:root)
    end

    context 'when called' do
      before do
        game.instance_variable_set(:@current_position, [0, 0])
        game.instance_variable_set(:@finish_position, [2, 3])
      end

      it 'calls #root on an object of Knight class' do
        expect(knight).to receive(:root)
        game.create_positions_tree
      end
    end

    context 'when @current_position and @finish_position are equal' do
      before do
        game.instance_variable_set(:@current_position, [0, 0])
        game.instance_variable_set(:@finish_position, [0, 0])
      end

      it 'does not create the tree' do
        expect(game).not_to receive(:add_nodes_to_tree)
        game.create_positions_tree
      end
    end

    context 'when @current_position and @finish_position are not equal' do
      before do
        game.instance_variable_set(:@current_position, [0, 0])
        game.instance_variable_set(:@finish_position, [2, 3])
      end

      it 'does create the tree' do
        expect(game).to receive(:add_nodes_to_tree).once
        game.create_positions_tree
      end
    end
  end
end
