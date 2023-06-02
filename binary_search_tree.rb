# Node for a Binary Search Tree, contains value/data, left and right children
class Node
  include Comparable
  attr_accessor :value, :left, :right, :height

  def initialize(value = nil, height = 1, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
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

    get_height(node.left) - get_height(node.right)
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
    current_root.left = build_branch(array.slice(0, mid_index))
    current_root.right = build_branch(array.slice(mid_index + 1, mid_index))
    current_root.height = 1 + [get_height(current_root.left), get_height(current_root.right)].max

    current_root
  end

  # can either do simple insert or a self-balancing insert
  def insert(value, self_balance = true)
    if @root.nil?
      @root = Node.new(value)
    elsif self_balance
      insert_traversal_balanced(value, @root)
    else
      insert_traversal_unbalanced(value, @root)
    end
  end

  # This is an AVL tree insertion to maintain balance
  def insert_traversal_balanced(value, node)

    # Normal BST insertion
    # Note: In case value == node.value, tree traversal stops
    # This prevents duplicates
    if node.nil?
      return Node.new(value)
    elsif value < node.value
      node.left = insert_traversal_balanced(value, node.left)
    elsif value > node.value
      node.right = insert_traversal_balanced(value, node.right)
    end

    # Update height of node
    node.height = 1 + [get_height(node.left), get_height(node.right)].max

    # Get balance factor
    balance = height_balance(node)

    # If node is unbalanced, do a rotate to re-balance the tree
    # Left left case
    return right_rotate(node) if balance > 1 && value < node.left.value

    # Right right case
    return left_rotate(node) if balance < -1 && value > node.right.value

    # Left right case
    if balance > 1 && value > node.left.value
      node.left = left_rotate(node.left)
      return right_rotate(node)
    end

    # Right left case
    if balance < -1 && value < node.right.value
      node.right = right_rotate(node.right)
      return left_rotate(node)
    end

    node
  end

  # This is the simple BST insertion
  # It can result in an unbalanced tree
  def insert_traversal_unbalanced(value, node)

    # Note: In case value == node.value, tree traversal stops
    # This prevents duplicates
    if node.nil?
      return Node.new(value)
    elsif value < node.value
      node.left = insert_traversal_unbalanced(value, node.left)
    elsif value > node.value
      node.right = insert_traversal_unbalanced(value, node.right)
    end

    node
  end

  def delete(value, self_balance = true)
    if @root.nil?
      puts "Tree is empty. Deletion not possible."
    elsif self_balance
      delete_balanced(value, @root)
    else
      delete_unbalanced(value, @root)
    end
  end

  def delete_balanced(value, node)
    return nil if node.nil?

    if value < node.value
      node.left = delete_balanced(value, node.left)
    elsif value > node.value
      node.right = delete_balanced(value, node.right)
    elsif node.left.nil?
      temp = node.right
      node = nil
      return temp
    elsif node.right.nil?
      temp = node.left
      node = nil
      return temp
    else
      temp = get_min_value_node(node.right)
      node.value = temp.value
      node.right = delete_balanced(temp.value, node.right)
    end

    return nil if node.nil?

    # Update height
    node.height = 1 + [get_height(node.left), get_height(node.right)].max

    balance = height_balance(node)

    # Left left case
    return right_rotate(node) if balance > 1 && height_balance(node.left) >= 0

    # Right right case
    return left_rotate(node) if balance < - 1 && height_balance(node.right) <= 0

    # Left right case
    if balance > 1 && height_balance(node.left).negative?
      node.left = left_rotate(node.left)
      return right_rotate(node)
    end

    # Right left case
    if balance < -1 && height_balance(node.right).positive?
      node.right = right_rotate(node.right)
      return left_rotate(node)
    end

    node
  end

  def delete_unbalanced(value, node)
    return nil if node.nil?

    if value < node.value
      node.left = delete_unbalanced(value, node.left)
    elsif value > node.value
      node.right = delete_unbalanced(value, node.right)
    else # Found the value
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      else
        temp = get_min_value_node(node.right)
        node.value = temp.value
        node.right = delete(node.right, temp.value)
      end
    end

    return nil if node.nil?
  end

  # Go left until there is no more left
  def get_min_value_node(node)
    if node.nil? || node.left.nil?
      return node
    end

    return get_min_value_node(node.left)
  end

  def left_rotate(node)
    # temps
    y = node.right
    t_2 = y.left

    # Perform rotation
    y.left = node
    node.right = t_2

    # Update height of node
    node.height = 1 + [get_height(node.left), get_height(node.right)].max
    y.height = 1 + [get_height(y.left), get_height(y.right)].max

    # Update base root if it changed
    @root = y if node == @root
    
    y
  end

  def right_rotate(node)
    # temps
    y = node.left
    t_3 = y.right
    
    # Perform rotation
    y.right = node
    node.left = t_3

    # Update height of node
    node.height = 1 + [get_height(node.left), get_height(node.right)].max
    y.height = 1 + [get_height(y.left), get_height(y.right)].max

    # Update central root if it changed
    @root = y if node == @root
    
    y
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

#test_tree = Tree.new([24, 7, 14, 5, 9, 10, 4, 3, 11, 15])
test_tree = Tree.new([1])
test_tree.insert(4, true)
test_tree.insert(9, true)
test_tree.insert(13, true)
test_tree.pretty_print
test_tree.delete(9, true)
test_tree.pretty_print