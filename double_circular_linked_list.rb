# frozen_string_literal: true

require_relative 'node'

# Ruby realization of a double circular linked list.
class DoubleCircularList
  include Enumerable

  attr_accessor :head, :count

  def initialize
    @head = nil
    @count = 0
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

  def [](index)
    current = @head
    (index.abs % @count).times do
      current = if index.positive?
                  current.next_node
                else
                  current.prev_node
                end
    end
    current.value
  end

  def each
    current = @head
    @count.times do
      yield current
      current = current.next_node
    end
  end
end
