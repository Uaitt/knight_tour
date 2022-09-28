# frozen_string_literal: true
require_relative '../lib/game'
require_relative '../lib/knight'
require_relative '../lib/tree_node'

describe Game do
  subject(:game) { described_class.new }

  describe '#initialize' do
    context 'when called' do
      it 'send the ::new on the Knight class' do
        expect(Knight).to receive(:new)
        described_class.new
      end
    end
  end

  describe '#start' do
    let(:knight) { game.instance_variable_get(:@knight) }
    before do
      allow(game).to receive(:user_input).and_return([0, 0], [1, 2])
      allow(game).to receive(:play)
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
    let(:time) { 'start' }
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:puts).with('Invalid position, try again!')
    end

    context 'when user enters a valid input the first time' do
      before do
        allow(game).to receive(:gets).and_return('0,0', '0,0')
        allow(game).to receive(:valid_input?).with(%w[0 0]).and_return(true, true)
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
        expect(return_value).to eq([0, 0])
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
        expect(return_value).to eq([1, 1])
      end
    end
  end

  describe '#valid_input?' do
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

    context 'when given letters' do
      it 'is not valid input' do
        input = %w[a 2]
        expect(game).not_to be_valid_input(input)
      end

      it 'is not valid input' do
        input = %w[a b]
        expect(game).not_to be_valid_input(input)
      end
    end

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

    context 'when the current position is equal to the finish position' do
      before do
        game.instance_variable_set(:@current_position, [0, 0])
        game.instance_variable_set(:@finish_position, [0, 0])
      end

      it 'does not create the tree' do
        expect(game).not_to receive(:add_nodes_to_tree)
        game.create_positions_tree
      end
    end

    context 'when the current position is not equal to the finish position' do
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

  describe '#print_path' do
    let(:root_node) { double(TreeNode, parent: nil) }
    context 'when finish node has only one parent' do
      let(:node) { double(TreeNode, parent: root_node) }
      it 'prints two nodes' do
        allow(game).to receive(:puts)
        allow(game).to receive(:print_node)
        expect(game).to receive(:print_node).twice
        game.print_path(node)
      end

      it 'prints nodes in the right order' do
        allow(game).to receive(:print_node)
        expect(game).to receive(:print_node).with(root_node).ordered
        expect(game).to receive(:print_node).with(node).ordered
        game.print_path(node)
      end
    end

    context 'when finish node has a parent and a grand parent' do
      let(:parent_node) { double(TreeNode, parent: root_node) }
      let(:node) { double(TreeNode, parent: parent_node) }
      it 'prints three nodes' do
        allow(game).to receive(:puts)
        allow(game).to receive(:print_node)
        expect(game).to receive(:print_node).exactly(3).times
        game.print_path(node)
      end

      it 'prints nodes in the right order' do
        allow(game).to receive(:print_node)
        expect(game).to receive(:print_node).with(root_node).ordered
        expect(game).to receive(:print_node).with(parent_node).ordered
        expect(game).to receive(:print_node).with(node).ordered
        game.print_path(node)
      end
    end
  end

  describe '#add_nodes_to_tree' do
    let(:nodes_queue) { game.instance_variable_set(:@nodes_queue, []) }
    before do
      allow(game).to receive(:add_children_to_node)
      allow(game).to receive(:last_position_in_queue)
    end

    context 'when a root child represents the finished position' do
      it 'stops the loop at the first iteration' do
        allow(game).to receive(:finished_path?).and_return(true)
        expect(game).to receive(:add_children_to_node).once
        game.add_nodes_to_tree
      end
    end

    context 'when a root grandchild represents the finished position' do
      it 'stops the loop at the second iteration' do
        allow(game).to receive(:finished_path?).and_return(false, true)
        expect(game).to receive(:add_children_to_node).twice
        game.add_nodes_to_tree
      end
    end

    context 'when a root great grandchild represents the finished position' do
      it 'stops the loop at the second iteration' do
        allow(game).to receive(:finished_path?).and_return(false, false, true)
        expect(game).to receive(:add_children_to_node).exactly(3).times
        game.add_nodes_to_tree
      end
    end
  end

  describe '#add_children_to_node' do
    let(:node) { double(TreeNode) }
    before do
      allow(game).to receive(:manage_child)
    end

    context 'when first child represents the finish position' do
      it 'exits the loop on the first iteration' do
        allow(game).to receive(:finished_path?).and_return(true)
        expect(game).to receive(:manage_child).once
        game.add_children_to_node(node)
      end
    end

    context 'when second child represents the finish position' do
      it 'exits the loop on the second iteration' do
        allow(game).to receive(:finished_path?).and_return(false, true)
        expect(game).to receive(:manage_child).twice
        game.add_children_to_node(node)
      end
    end

    context 'when fourth child represents the finish position' do
      it 'exits the loop on the fourth iteration' do
        allow(game).to receive(:finished_path?).and_return(false, false, false, true)
        expect(game).to receive(:manage_child).exactly(4).times
        game.add_children_to_node(node)
      end
    end
  end

  describe '#last_position_in_queue' do
    let(:nodes_queue) { game.instance_variable_get(:@nodes_queue) }
    let(:node) { double(TreeNode) }
    context 'when called' do
      it 'sends the position message to a node' do
        allow(nodes_queue).to receive(:[]).and_return(node)
        allow(node).to receive(:position)
        expect(node).to receive(:position)
        game.last_position_in_queue
      end
    end
  end

  describe '#manage_child' do
    let(:node) { double(TreeNode) }
    before do
      allow(game).to receive(:calculate_current_position)
      allow(game).to receive(:add_child)
    end
    context 'when position is valid' do
      it 'adds the current node as child in the tree' do
        allow(game).to receive(:valid_position?).and_return(true)
        expect(game).to receive(:add_child)
        child_number = 0
        game.manage_child(node, child_number)
      end
    end

    context 'when position is invalid' do
      it 'does not add the current node as child in the tree' do
        allow(game).to receive(:valid_position?).and_return(false)
        expect(game).not_to receive(:add_child)
        child_number = 1
        game.manage_child(node, child_number)
      end
    end
  end

  describe '#calculate_current_position' do
    let(:node) { double(TreeNode) }
    let(:knight) { game.instance_variable_get(:@knight) }
    let(:child) { 0 }
    before do
      allow(node).to receive(:position).and_return([0, 0])
      allow(knight).to receive(:possible_moves).and_return([[1, 2], [-1, 2]])
    end

    context 'when called' do
      it 'sends the position message on a tree node' do
        expect(node).to receive(:position).twice
        game.calculate_current_position(node, child)
      end

      it 'sends the possible_moves message on a knight' do
        expect(knight).to receive(:possible_moves).twice
        game.calculate_current_position(node, child)
      end

      it 'assigns the correct values to the instance variable' do
        game.calculate_current_position(node, child)
        current_position = game.instance_variable_get(:@current_position)
        expected_position = [1, 2]
        expect(current_position).to eq(expected_position)
      end
    end
  end

  describe '#valid_position?' do
    let(:board) { game.instance_variable_get(:@board) }

    context 'when given a valid cell and it is not already occupied' do
      it 'is a valid position' do
        game.instance_variable_set(:@current_position, [1, 2])
        board = game.instance_variable_get(:@board)
        board[1][2] = 0
        expect(game).to be_valid_position
      end
    end

    context 'when given an out of range cell' do
      it 'is not a valid position' do
        game.instance_variable_set(:@current_position, [-1, 2])
        expect(game).not_to be_valid_position
      end
    end

    context 'when given a valid cell but it is already occupied' do
      it 'is not a valid position' do
        game.instance_variable_set(:@current_position, [3, 4])
        board = game.instance_variable_get(:@board)
        board[3][4] = 1
        expect(game).not_to be_valid_position
      end
    end
  end

  describe '#create_child' do
    context 'when called' do
      let(:node) { double(TreeNode, next_nodes: []) }
      it 'sends the message next_nodes to a node object' do
        allow(TreeNode).to receive(:new)
        game.instance_variable_set(:@current_position, [0, 0])
        expect(node).to receive(:next_nodes).once
        game.create_child(node)
      end
    end
  end
end
