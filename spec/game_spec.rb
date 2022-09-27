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
          allow(game).to receive(:input_valid?).with(['0', '0']).and_return(true, true)
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
          allow(game).to receive(:input_valid?).and_return(false, true)
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
end
