# A single element that stores only its own value and a pointer to the next Node in the linked list
class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end

end

# LinkedList implements a linear Linked List data structure within ruby
# It stores size, head and tail. It's possible to ONLY store head...
# ...but then some basic operations like append would have time-complexity of O(n) instead of O(1)
class LinkedList
  attr_reader :head, :tail, :size

  def initialize(first_node = nil)
    @head = first_node
    @tail = first_node
    @size = first_node.nil? ? 0 : 1
  end

  def append(new_node)
    if head.nil?
      @head = new_node
    else
      @tail.next_node = new_node
    end
    @tail = new_node
    @size += 1
  end

  def prepend(new_node)
    if head.nil?
      @tail = new_node
    else
      new_node.next_node = @head
    end
    @head = new_node
    @size += 1
  end

  def pop
    remove_at(@size - 1)
  end

  # shifts current node at index to the RIGHT
  def insert_at(value, index)
    if index >= size
      puts "Error! Index outside bounds."
      return nil
    end

    # Will never need to update @tail because you cannot insert at end
    if index.zero?
      @head = Node.new(value, @head)
    else
      before_node = at(index - 1)
      before_node.next_node = Node.new(value, before_node.next_node)
    end

    @size += 1
  end

  def remove_at(index)
    if index >= size
      puts "Error! Index outside bounds."
      return nil
    end

    node_to_remove = at(index)
    prev_node = at(index - 1)
    if index.zero?
      @head = @head.next_node
    elsif index == @size - 1
      @tail = prev_node
      @tail.next_node = nil
    else
      prev_node.next_node = node_to_remove.next_node
    end

    @size -= 1
    node_to_remove
  end

  def at(index)
    if index >= size
      puts "Error! Index outside bounds."
      return nil
    end

    current_node = @head
    index.times do
      current_node = current_node.next_node
      return nil if current_node.nil?
    end
    current_node
  end

  def contains?(value_query)
    return false if head.nil?

    current_node = @head
    @size.times do
      return true if current_node.value == value_query

      current_node = current_node.next_node
    end

    false
  end

  def find(value_query)
    return nil if head.nil?

    current_index = 0
    current_node = @head
    @size.times do
      return current_index if current_node.value == value_query

      current_node = current_node.next_node
      current_index += 1
    end

    nil
  end

  def to_s
    total_string = ''
    current_node = @head
    @size.times do
      total_string += "( #{current_node.value} ) -> "
      current_node = current_node.next_node
    end

    "#{total_string}nil"
  end

  private

  def manual_size
    return 0 if head.nil?

    count = 1
    current_node = @head
    loop do
      break if current_node.next_node.nil?

      current_node = current_node.next_node
      count += 1
    end

    count
  end
end