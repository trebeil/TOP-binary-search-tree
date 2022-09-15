require_relative './node'
require_relative './tree'

tree = Tree.new(Array.new(15) { rand(1..100) })
puts
puts 'Tree:'
tree.pretty_print
puts
puts "Tree is balanced (true/false): #{tree.balanced?}"
puts
puts 'Nodes in level order:'
tree.level_order_recursion { |node| puts node.data }
puts
puts 'Nodes in preorder:'
tree.preorder { |node| puts node.data }
puts
puts 'Nodes in postorder:'
tree.postorder { |node| puts node.data }
puts
puts 'Nodes inorder:'
tree.inorder { |node| puts node.data }
10.times do
  tree.insert(rand(101..200))
end
puts
puts 'Unbalanced tree with additional elements:'
tree.pretty_print
puts
puts "Tree is balanced (true/false): #{tree.balanced?}"
tree = tree.rebalance
puts 'Rebalanced tree:'
tree.pretty_print
puts
puts "Tree is balanced (true/false): #{tree.balanced?}"
puts
puts 'Nodes in level order:'
tree.level_order_recursion { |node| puts node.data }
puts
puts 'Nodes in preorder:'
tree.preorder { |node| puts node.data }
puts
puts 'Nodes in postorder:'
tree.postorder { |node| puts node.data }
puts
puts 'Nodes inorder:'
tree.inorder { |node| puts node.data }
