# frozen_string_literal: true

# Represents a node of a double circular linked list.
class Node

  # the value of a node - anything you want to store in a list
  attr_accessor :value

  # the node which points to this node
  attr_accessor :prev_node

  # the pointer to the next node
  attr_accessor :next_node

  # ==== Options
  #
  # * +:prev_node+ - previous node of the list, if not given, points to itself
  # * +:value+ - a value of a node, default - +nil+
  # * +:next_node+ - next node of the list, if not given, points to itself
  def initialize(prev_node: nil, value: nil, next_node: nil)
    @value = value
    @prev_node = prev_node || self
    @next_node = next_node || self
  end
end
