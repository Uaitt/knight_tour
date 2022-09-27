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
end
