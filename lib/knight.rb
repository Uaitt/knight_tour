# frozen_string_literal: true

# this class represents a knight in chess
class Knight
  attr_reader :possible_moves, :root

  def initialize(input)
    @possible_moves = [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    @root = TreeNode.new(input)
  end
end
