# frozen_string_literal: true

# every node represents the position of the knight at a given time
class TreeNode
  attr_reader :position, :parent
  attr_accessor :next_nodes

  def initialize(pos, parent = nil)
    @position = pos
    @parent = parent
    @next_nodes = []
  end
end
