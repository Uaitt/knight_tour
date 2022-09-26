# frozen_string_literal: true

# this class represents the whole game
class Game
  def initialize
    @board = Array.new(8) { Array.new(8, 0) }
    @knight = Knight.new
    @nodes_queue = []
  end

  def start_game
    @start_position = user_input('start')
    @finish_position = user_input('finish')

    @knight.create_tree_root(@start_position)
    play_game
  end

  def user_input(time)
    puts "Enter the #{time} position (a,b) of the knight: "
    loop do
      input = gets.chomp.split(',').map(&:to_i)
      return input if input.length == 2

      puts 'Invalid position, try again!'
    end
  end

  def play_game
    finish_position_node = create_positions_tree

    print_path(finish_position_node)
  end

  def create_positions_tree
    add_root_node_to_queue
    add_nodes_to_tree

    nodes_queue[nodes_queue.length - 1]
  end

  def add_root_node_to_queue
    @nodes_queue.push(@knight.root)
    @board[0][0] = 1
  end

  def add_nodes_to_tree
    loop do
      node = @nodes_queue.shift
      add_children_to_node(node)
      break if nodes_queue[-1].position == @finish_position
    end
  end

  def add_children_to_node(node, nodes_queue, finish)
    child = 0
    while child < 8
      row_position = node.position[0] + @knight.possible_moves[child][0]
      column_position = node.position[1] + @knight.possible_moves[child][1]
      if (0..7).member?(row_position) && (0..7).member?(column_position) && @board[row_position][column_position].zero?
        new_node = TreeNode.new([row_position, column_position], node)
        node.next_nodes << new_node
        nodes_queue << new_node
        @board[row_position][column_position] = 1
      end
      child += 1
      return if [row_position, column_position] == finish
    end
  end

  def print_path(node, moves = 0)
    if node.parent.nil?
      puts "You made it in #{moves} move#{"s" if moves > 1}! Here's your path: "
      p node.position
      puts ''
      return
    end
    print_path(node.parent, moves += 1)
    p node.position
    puts ''
  end
end
