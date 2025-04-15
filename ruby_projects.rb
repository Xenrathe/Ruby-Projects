require_relative './Ruby-BinarySearchTree/binary_search_tree'
require_relative './Ruby-ConnectFour/lib/connect_four_main'
require_relative './Ruby-Hangman/hangman'
require_relative './Ruby-KnightsTravails/knights_travails'
require_relative './Ruby-LinkedList/linked_list'
require_relative './Ruby-MasterMind/master_mind'

def main_menu
  loop do
    puts
    puts "=== Ruby Projects CLI ==="
    puts "1. Binary Search Tree"
    puts "2. Connect Four"
    puts "3. Hangman"
    puts "4. Knights Travails"
    puts "5. Linked List"
    puts "6. MasterMind"
    puts "7. Exit"
    print "> "
    choice = gets.chomp.strip

    case choice
    when "1"
      BinarySearchTree.prompt
    when "2"
      ConnectFourMain.new_game
    when "3"
      Hangman.play_round
    when "4"
      KnightsTravails.prompt
    when "5"
      LinkedListMain.prompt
    when "6"
      MasterMind.initialize_game
    when "7"
      puts "See ya!"
      break
    else
      puts "Invalid choice. Try again."
      gets
    end
  end
end

main_menu