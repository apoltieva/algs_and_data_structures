# frozen_string_literal: true

require_relative 'node'

# Ruby realization of a double circular linked list.
class DoubleCircularList
  include Enumerable

  attr_accessor :head, :count

  def initialize(input_ary = nil)
    @count = 0
    input_ary&.each { |element| self << element }
  end

  def <<(value)
    if @head
      prev_node = @head.prev_node
      new_node = Node.new(prev_node: prev_node, value: value, next_node: @head)
      prev_node.next_node = new_node
      @head.prev_node = new_node
    else
      @head = Node.new(value: value)
    end
    @count += 1
    @head.prev_node
  end

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

  def each
    current = @head
    @count.times do
      yield current
      current = current.next_node
    end
  end

  def remove_node(node)
    if @count == 1
      @count = 0
      @head = nil
    else
      @head = node.next_node if node == @head
      node.prev_node.next_node = node.next_node
      node.next_node.prev_node = node.prev_node
      @count -= 1
      node
    end
  end

  def traverse_to_node(index, current, as_many_as_said: false)
    (as_many_as_said ? index.abs : index.abs % @count).times do
      yield current if block_given?
      current = index.positive? ? current.next_node : current.prev_node
    end
    yield current if block_given?
    current
  end
end
