# frozen_string_literal: true
require_relative '../lib/game'
require_relative '../lib/knight'
require_relative '../lib/tree_node'

describe Game do
  subject(:game) { described_class.new }

  describe '#initialize' do
    context 'when called'
      it 'calls ::new on Knight' do
        expect(Knight).to receive(:new)
        described_class.new
      end
    end
  end

  
end
