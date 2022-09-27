# frozen_string_literal: true

# this class represents the whole game
class Game
  def initialize # you can check if ::new is called on Knight
    @board = Array.new(8) { Array.new(8, 0) }
    @knight = Knight.new
    @nodes_queue = []
  end

  def start # outgoing command script method, stub every thing and check that @knight receives
    @current_position = user_input('start')
    @finish_position = user_input('finish')

    @knight.create_tree_root(@current_position)
    play_game
  end

  def user_input(time) # looping script method, check how the loop behaves with different inputs
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

  def play_game
    create_positions_tree

    print_path(@nodes_queue[-1])
  end

  def create_positions_tree # check the outgoing command the the conditional branch
    @nodes_queue << @knight.root #check that this message is sent
    @board[@current_position[0]][@current_position[1]] = 1

    add_nodes_to_tree if @current_position != @finish_position # check if the method is called or not
  end

  def add_nodes_to_tree # looping script method, check how this loop behaves
    loop do
      node = @nodes_queue.shift
      add_children_to_node(node)
      break if @nodes_queue[-1].position == @finish_position
    end
  end

  def add_children_to_node(node)
    child_number = 0
    while child_number < 8
      calculate_current_position(node, child_number)
      add_child(node) if position_valid?
      break if @current_position == @finish_position

      child_number += 1
    end
  end

  def calculate_current_position(node, child)
    @current_position = []
    @current_position[0] = node.position[0] + @knight.possible_moves[child][0]
    @current_position[1] = node.position[1] + @knight.possible_moves[child][1]
  end

  def position_valid?
    (0..7).member?(@current_position[0]) && (0..7).member?(@current_position[1]) &&
      @board[@current_position[0]][@current_position[1]].zero?
  end

  def add_child(node)
    new_node = TreeNode.new([@current_position[0], @current_position[1]], node)
    node.next_nodes << new_node

    @nodes_queue << new_node
    @board[@current_position[0]][@current_position[1]] = 1
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
