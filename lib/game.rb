# frozen_string_literal: true

# this class represents the whole game
class Game
  def initialize
    @board = Array.new(8) { Array.new(8, 0) }
    @knight = Knight.new
    @nodes_queue = []
  end

  def start
    @current_position = user_input('start')
    @finish_position = user_input('finish')

    @knight.create_tree_root(@current_position)
    play
  end

  def user_input(time)
    puts "Enter the #{time} position (a,b) of the knight.\nA coordinate must be a number between 0 and 7. "
    loop do
      input = gets.chomp.split(',')
      return input.map(&:to_i) if valid_input?(input)

      puts 'Invalid position, try again!'
    end
  end

  def valid_input?(input)
    input.length == 2 && ('0'..'7').member?(input[0]) && ('0'..'7').member?(input[1])
  end

  def play
    create_positions_tree

    print_path(@nodes_queue[-1])
  end

  def create_positions_tree
    add_child_to_queue(@knight.root)

    add_nodes_to_tree if @current_position != @finish_position
  end

  def add_child_to_queue(new_node)
    @nodes_queue << new_node
    @board[@current_position[0]][@current_position[1]] = 1
  end

  def add_nodes_to_tree
    loop do
      node = @nodes_queue.shift
      add_children_to_node(node)
      last_position = last_position_in_queue
      break if finished_path?(last_position, @finish_position)
    end
  end

  def add_children_to_node(node)
    child_number = 0
    while child_number < 8
      manage_child(node, child_number)
      break if finished_path?(@current_position, @finish_position)

      child_number += 1
    end
  end

  def last_position_in_queue
    @nodes_queue[-1].position
  end

  def finished_path?(current_position, finish_position)
    current_position == finish_position
  end

  def manage_child(node, child_number)
    calculate_current_position(node, child_number)
    add_child(node) if valid_position?
  end

  def calculate_current_position(node, child)
    @current_position = []
    @current_position[0] = node.position[0] + @knight.possible_moves[child][0]
    @current_position[1] = node.position[1] + @knight.possible_moves[child][1]
  end

  def valid_position?
    (0..7).member?(@current_position[0]) && (0..7).member?(@current_position[1]) &&
      @board[@current_position[0]][@current_position[1]].zero?
  end

  def add_child(node)
    new_node = create_child(node)

    add_child_to_queue(new_node)
  end

  def create_child(node)
    new_node = TreeNode.new([@current_position[0], @current_position[1]], node)
    node.next_nodes << new_node
    new_node
  end

  def print_path(node, moves = 0)
    if node.parent.nil?
      puts "You made it in #{moves} move#{'s' if moves > 1}! Here's your path: "
      print_node(node)
      return
    end
    print_path(node.parent, moves + 1)
    print_node(node)
  end

  def print_node(node)
    p node.position
    puts ''
  end
end
