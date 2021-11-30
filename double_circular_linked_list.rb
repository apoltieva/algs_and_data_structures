# frozen_string_literal: true

require_relative 'node'

# Ruby realization of a double circular linked list which contains objects of class <tt>@Node</tt>.
class DoubleCircularList
  include Enumerable

  # The first node of a list. Points to +nil+ if list is empty.
  attr_accessor :head

  # The size of the list.
  attr_accessor :size
  alias length size

  # Creates a new list.
  # === Options
  #
  # * +:input_ary+ - any iterable with #each that is used to populate the list with values.
  #   Default is +nil+.
  def initialize(input_ary = nil)
    @size = 0
    input_ary&.each { |element| self << element }
  end

  # Creates a new node with the given value at the end of the list.
  #
  # === Attributes
  #
  # * +value+ - an object that will be stored in the list.
  def <<(value)
    if @head
      prev_node = @head.prev_node
      new_node = Node.new(prev_node: prev_node, value: value, next_node: @head)
      prev_node.next_node = new_node
      @head.prev_node = new_node
    else
      @head = Node.new(value: value)
    end
    @size += 1
    @head.prev_node
  end

  # If integer is given, returns a *node* with the index equal to the int. If range is given, returns an Array which is
  # the slice of the list with indeces of the given range.
  #
  # NB! returns nodes, not just their values
  def [](index_or_range)
    current = @head
    case index_or_range
    when Integer
      traverse_to_node(index_or_range, current)
    when Range
      result = []
      current = traverse_to_node(index_or_range.begin, current)
      last_node_index = index_or_range.end - (index_or_range.exclude_end? ? 2 : 1)
      traverse_to_node(last_node_index, current, as_many_as_said: true) { |node| result << node }
      result
    else
      raise TypeError, "expected an Integer or a Range, got #{index_or_range.class}"
    end
  end

  # Same as Array#each
  def each
    current = @head
    @size.times do
      yield current
      current = current.next_node
    end
  end

  # Same as Array#delete_at
  def delete_at(index)
    if @size.zero?
      nil
    else
      remove_node traverse_to_node(Integer(index), @head)
    end
  end

  # Deletes the first node that has the value of +value+.
  # If block is given, returns its value, else +nil+.
  #
  # === Attributes
  # * +value+ - the value of the node to be deleted.
  def delete(value)
    current = @head
    while current.value != value
      current = current.next_node
      if current == @head
        if block_given?
          return yield
        else
          return nil
        end
      end
    end
    remove_node current
  end

  # Removes the node from the list.
  # === Attributes
  # * +node+ - the node to remove
  def remove_node(node)
    raise TypeError, "expected a Node, got #{node.class}" unless node.is_a? Node

    if @size == 1
      @size = 0
      @head = nil
    else
      @head = node.next_node if node == @head
      node.prev_node.next_node = node.next_node
      node.next_node.prev_node = node.prev_node
      @size -= 1
      node
    end
  end

  # Goes through the list from +current+ node to the DoubleCircularList \[+index+\] node, executing block if given.
  # === Attributes
  # * +index+ - the index of the destination node (can be more than the size of the list, positive or negative)
  # * +current+ - the starting node
  # * +:as_many_as_said+ - if false, traversing goes _n_ times where _n_ is the index of the resulting node.
  #   Else goes through the list exactly +index+ times.
  #
  #   === Example
  #     list = DoubleCircularList.new [0, 1, 2]
  #     node = list.traverse_to_node(5, list.head) {|node| puts node.value} # prints 0 1 2 and returns 2
  #     node = list.traverse_to_node(5, list.head, as_many_as_said: true) {|node| puts node.value} # prints 0 1 2 0 1 2 and returns 2
  def traverse_to_node(index, current, as_many_as_said: false)
    return nil if @size.zero?

    (as_many_as_said ? index.abs : index.abs % @size).times do
      yield current if block_given?
      current = index.positive? ? current.next_node : current.prev_node
    end
    yield current if block_given?
    current
  end
end
