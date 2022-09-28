# frozen_string_literal: true

require_relative '../lib/knight'
require_relative '../lib/tree_node'

describe Knight do
  subject(:knight) { described_class.new }
  describe '#create_tree_root' do
    context 'when called' do
      it 'sends the ::new message to the TreeNode class' do
        start_position = [0, 0]
        expect(TreeNode).to receive(:new).with(start_position)
        knight.create_tree_root(start_position)
      end
    end
  end
end
