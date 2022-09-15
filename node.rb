class Node
  attr_accessor :data, :left, :right

  include Comparable

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end
