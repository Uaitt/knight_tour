# frozen_string_literal: true

# this class represents the whole game
class Game
  def initialize
    @board = Array.new(8) { Array.new(8, 0) }

    start = ask_for_start
    finish = ask_for_finish

    @knight = Knight.new(start)

    play_game(finish)
  end

  def ask_for_start
    user_input = false
    until user_input
      puts 'Enter the starting position of the knight (a,b format): '
      start = gets.chomp.split(',').map(&:to_i)
      if start.length != 2
        puts 'A position is made up of 2 cordinates! Try again.'
      else
        user_input = true
      end
    end
    start
  end

  def ask_for_finish
    user_input = false
    until user_input
      puts 'Enter the ending position of the knight (a,b format): '
      finish = gets.chomp.split(',').map(&:to_i)
      if finish.length != 2
        puts 'A position is made up of 2 cordinates! Try again.'
      else
        user_input = true
      end
    end
    finish
  end

  def play_game(finish)
    finish_position_node = create_knight_positions_tree(finish)

    print_path(finish_position_node)
  end

  def create_knight_positions_tree(finish)
    nodes_queue = []
    nodes_queue.push(@knight.root)
    @board[0][0] = 1
    loop do
      node = nodes_queue.shift
      add_children_to_node(node, nodes_queue, finish)
      break if nodes_queue[nodes_queue.length - 1].position == finish
    end
    nodes_queue[nodes_queue.length - 1]
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
end
