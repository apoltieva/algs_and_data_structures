# frozen_string_literal: true

# Represents a node used in double circular linked list.
# Has a value and 2 pointers - for the previous node in a linked list and for the next one.
# If previous and next node are not given, it points to itself, creating a cyclic object.
class Node
  attr_accessor :prev_node, :value, :next_node

  def initialize(prev_node: nil, value: nil, next_node: nil)
    @value = value
    @prev_node = prev_node || self
    @next_node = next_node || self
  end
end
