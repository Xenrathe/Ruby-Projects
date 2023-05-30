# Node for a Binary Search Tree, contains value/data, left and right children
class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child

  def initialize(value = nil, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(other)
    value <=> other.value
  end

end

class Tree
  attr_accessor :root

  def initialize(data_array = [])
    build_tree(data_array)
  end

  def build_tree(input_array)
    return nil if input_array.empty?

    input_array = input_array.uniq.sort
    @root = branch(input_array)
  end

  def branch(array)
    return nil if array.empty?

    mid_index = array.size / 2
    current_root = Node.new(array[mid_index])
    current_root.left_child = branch(array.slice(0, mid_index))
    current_root.right_child = branch(array.slice(mid_index + 1, mid_index))

    current_root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

test_tree = Tree.new([24, 7, 14, 15, 5, 5, 9, 10, 4, 3, 11, 15])
test_tree.pretty_print