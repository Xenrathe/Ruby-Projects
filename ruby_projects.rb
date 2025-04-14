require_relative './Ruby-BinarySearchTree/binary_search_tree'

def main_menu
  loop do
    puts
    puts "=== Ruby Projects CLI ==="
    puts "1. Binary Search Tree"
    puts "2. Exit"
    print "> "
    choice = gets.chomp.strip

    case choice
    when "1"
      BinarySearchTree.prompt
    when "2"
      puts "See ya!"
      break
    else
      puts "Invalid choice. Try again."
      gets
    end
  end
end

main_menu