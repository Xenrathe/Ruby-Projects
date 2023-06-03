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

  def to_s
    "Node:[val: #{value} H: #{height}]"
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
    @root = build_branch(input_array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def find(value)
    found_node = find_machinery(value, @root)
    if found_node.nil?
      puts "#{value} not found in tree."
    else
      puts "#{value} found in #{found_node}"
    end

    found_node
  end

  # can either do simple insert or a self-balancing insert
  def insert(value, self_balance = true)
    if @root.nil?
      @root = Node.new(value)
    elsif self_balance
      insert_balanced(value, @root)
    else
      insert_unbalanced(value, @root)
    end
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

  def level_order_iter
    queue_of_nodes = [@root]
    array_of_values = []

    until queue_of_nodes.empty?
      queue_of_nodes.push(queue_of_nodes[0].left) unless queue_of_nodes[0].left.nil?
      queue_of_nodes.push(queue_of_nodes[0].right) unless queue_of_nodes[0].right.nil?

      if block_given?
        yield queue_of_nodes.shift
      else
        array_of_values.push(queue_of_nodes.shift.value)
      end
    end

    array_of_values
  end

  def level_order_recursive(array_of_values = [], queue_of_nodes = [@root], &block)
    if queue_of_nodes.empty?
      block.call(Node.new(nil)) if block_given?
      return array_of_values
    end

    queue_of_nodes.push(queue_of_nodes[0].left) unless queue_of_nodes[0].left.nil?
    queue_of_nodes.push(queue_of_nodes[0].right) unless queue_of_nodes[0].right.nil?
    
    if block_given?
      block.call(queue_of_nodes.shift)
    else
      array_of_values.push(queue_of_nodes.shift.value)
    end

    level_order_recursive(array_of_values, queue_of_nodes, &block)
    array_of_values
  end

  def inorder(node = @root, array_of_values = [], &block)
    return if node.nil?

    inorder(node.left, array_of_values, &block)

    if block_given?
      block.call(node)
    else
      array_of_values.push(node.value)
    end

    inorder(node.right, array_of_values, &block)

    array_of_values
  end

  def preorder(node = @root, array_of_values = [], &block)
    return if node.nil?

    if block_given?
      block.call(node)
    else
      array_of_values.push(node.value)
    end

    preorder(node.left, array_of_values, &block)
    preorder(node.right, array_of_values, &block)

    array_of_values
  end

  def postorder(node = @root, array_of_values = [], &block)
    return if node.nil?

    postorder(node.left, array_of_values, &block)
    postorder(node.right, array_of_values, &block)

    if block_given?
      block.call(node)
    else
      array_of_values.push(node.value)
    end

    array_of_values
  end

  # Height is stored in node
  def height(node)
    return 0 if node.nil?
    
    node.height
  end

  # Alternatively, could store depth during node and keep track during initialize, insert, delete
  def depth(node, current_node = @root, count = 0)
    return -1 if node.nil?

    if node == current_node
      count
    elsif node.value < current_node.value
      count += 1
      depth(node, current_node.left, count)
    else
      count += 1
      depth(node, current_node.right, count)
    end
  end

  # Using level_order, check every node's height-balance
  def balanced?
    level_order_iter { |node| return false if height_balance(node).abs > 1 }
    true
  end

  def rebalance
    build_tree(inorder)
  end

  private

  def height_balance(node)
    return 0 if node.nil?

    height(node.left) - height(node.right)
  end

  def build_branch(array)
    return nil if array.empty?

    mid_index = array.size / 2
    current_root = Node.new(array[mid_index])
    current_root.left = build_branch(array.slice(0, mid_index))
    current_root.right = build_branch(array.slice(mid_index + 1, mid_index))
    current_root.height = 1 + [height(current_root.left), height(current_root.right)].max

    current_root
  end

  def find_machinery(value, node)
    return nil if node.nil?

    if value == node.value
      node
    elsif value < node.value
      find_machinery(value, node.left)
    else
      find_machinery(value, node.right)
    end
  end

  # This is an AVL tree insertion to maintain balance
  def insert_balanced(value, node)

    # Normal BST insertion
    # Note: In case value == node.value, tree traversal stops
    # This prevents duplicates
    if node.nil?
      return Node.new(value)
    elsif value < node.value
      node.left = insert_balanced(value, node.left)
    elsif value > node.value
      node.right = insert_balanced(value, node.right)
    end

    # Update height of node
    node.height = 1 + [height(node.left), height(node.right)].max

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
  def insert_unbalanced(value, node)

    if node.nil?
      return Node.new(value)
    elsif value < node.value
      node.left = insert_unbalanced(value, node.left)
    elsif value > node.value
      node.right = insert_unbalanced(value, node.right)
    end

    # Update height of node
    node.height = 1 + [height(node.left), height(node.right)].max

    node
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
    node.height = 1 + [height(node.left), height(node.right)].max

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
        node.right = delete_unbalanced(temp.value, node.right)
      end
    end

    return nil if node.nil?

    # Update height
    node.height = 1 + [height(node.left), height(node.right)].max

    node
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
    node.height = 1 + [height(node.left), height(node.right)].max
    y.height = 1 + [height(y.left), height(y.right)].max

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
    node.height = 1 + [height(node.left), height(node.right)].max
    y.height = 1 + [height(y.left), height(y.right)].max

    # Update central root if it changed
    @root = y if node == @root
    
    y
  end
end

test_tree = Tree.new(Array.new(15) { rand(1..100) })
test_tree.pretty_print
if test_tree.balanced?
  puts "Tree is initially balanced."
else
  puts "Tree is initially unbalanced."
end

print "Level_order array: #{test_tree.level_order_recursive}\n"
print "In order array: #{test_tree.inorder}\n"
print "Preorder array: #{test_tree.preorder}\n"
print "Postorder via block: "
test_tree.postorder do |node|
  print "#{node.value} -> "
end
print "\n"

4.times do
  test_tree.insert(rand(101..150), false)
end
test_tree.pretty_print
if test_tree.balanced?
  puts "Tree is balanced."
else
  puts "Tree is unbalanced."
end

test_tree.rebalance
test_tree.pretty_print
if test_tree.balanced?
  puts "Tree is balanced."
else
  puts "Tree is unbalanced."
end

print "Level_order array: #{test_tree.level_order_recursive}\n"
print "In order array: #{test_tree.inorder}\n"
print "Preorder array: #{test_tree.preorder}\n"
print "Postorder via block: "
test_tree.postorder do |node|
  print "#{node.value} -> "
end
print "\n"
