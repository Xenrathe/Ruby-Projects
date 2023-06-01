# Node for a Binary Search Tree, contains value/data, left and right children
class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child, :height

  def initialize(value = nil, height = 1, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
    @height = height
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

  def get_height(node)
    return 0 if node.nil?

    node.height
  end

  def height_balance(node)
    return 0 if node.nil?

    get_height(node.left_child) - get_height(node.right_child)
  end

  def build_tree(input_array)
    return nil if input_array.empty?

    input_array = input_array.uniq.sort
    @root = build_branch(input_array)
  end

  def build_branch(array)
    return nil if array.empty?

    mid_index = array.size / 2
    current_root = Node.new(array[mid_index])
    current_root.left_child = build_branch(array.slice(0, mid_index))
    current_root.right_child = build_branch(array.slice(mid_index + 1, mid_index))
    current_root.height = 1 + [get_height(current_root.left_child), get_height(current_root.right_child)].max

    current_root
  end

  # can either do simple insert or a self-balancing insert
  def insert(value, self_balance)
    if @root.nil?
      @root = Node.new(value)
    elsif self_balance
      insert_traversal_balanced(value, @root)
    else
      insert_traversal_unbalanced(value, @root)
    end
  end

  # This is an AVL tree insertion to maintain balance
  def insert_traversal_balanced(value, current_node)

    # Normal BST insertion
    # Note: In case value == current_node.value, tree traversal stops
    # This prevents duplicates
    if current_node.nil?
      return Node.new(value)
    elsif value < current_node.value
      current_node.left_child = insert_traversal_balanced(value, current_node.left_child)
    elsif value > current_node.value
      current_node.right_child = insert_traversal_balanced(value, current_node.right_child)
    end

    # Update height of node
    current_node.height = 1 + [get_height(current_node.left_child), get_height(current_node.right_child)].max

    # Get balance factor
    balance = height_balance(current_node)

    # If node is unbalanced, do a rotate to re-balance the tree
    # Left left case
    return rightRotate(current_node) if balance > 1 && value < current_node.left_child.value

    # Right right case
    return leftRotate(current_node) if balance < -1 && value > current_node.right_child.value

    # Left right case
    if balance > 1 && value > current_node.left_child.value
      current_node.left_child = leftRotate(current_node.left_child)
      return rightRotate(current_node)
    end

    # Right left case
    if balance < -1 && value < current_node.right_child.value
      current_node.right_child = rightRotate(current_node.right_child)
      return leftRotate(current_node)
    end

    current_node
  end

  # This is the simple BST insertion
  # It can result in an unbalanced tree
  def insert_traversal_unbalanced(value, current_node)

    # Note: In case value == current_node.value, tree traversal stops
    # This prevents duplicates
    if current_node.nil?
      return Node.new(value)
    elsif value < current_node.value
      current_node.left_child = insert_traversal_unbalanced(value, current_node.left_child)
    elsif value > current_node.value
      current_node.right_child = insert_traversal_unbalanced(value, current_node.right_child)
    end

    current_node
  end

  def leftRotate(node)
    # temps
    y = node.right_child
    t_2 = y.left_child

    # Perform rotation
    y.left_child = node
    node.right_child = t_2

    # Update height of node
    node.height = 1 + [get_height(node.left_child), get_height(node.right_child)].max
    y.height = 1 + [get_height(y.left_child), get_height(y.right_child)].max

    # Update base root if it changed
    @root = y if node == @root
    
    y
  end

  def rightRotate(node)
    # temps
    y = node.left_child
    t_3 = y.right_child
    
    # Perform rotation
    y.right_child = node
    node.left_child = t_3

    # Update height of node
    node.height = 1 + [get_height(node.left_child), get_height(node.right_child)].max
    y.height = 1 + [get_height(y.left_child), get_height(y.right_child)].max

    # Update central root if it changed
    @root = y if node == @root
    
    y
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

#test_tree = Tree.new([24, 7, 14, 5, 9, 10, 4, 3, 11, 15])
test_tree = Tree.new([1])
test_tree.pretty_print
test_tree.insert(4, true)
test_tree.insert(9, true)
test_tree.insert(13, true)
test_tree.pretty_print