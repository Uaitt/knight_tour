# frozen_string_literal: true

# this class represents a knight in chess
class Knight
  attr_reader :possible_moves, :root

  def initialize(input)
    @possible_moves = [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end

  def create_tree_root(start_position)
    @root = TreeNode.new(start_position)
  end
end
