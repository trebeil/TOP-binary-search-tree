class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array.sort.uniq, 0, array.sort.uniq.length - 1)
  end

  def build_tree(array, start_index, end_index)
    return nil if start_index > end_index

    mid = (start_index + end_index)/2
    Node.new(array[mid], build_tree(array, start_index, mid-1), build_tree(array, mid+1, end_index))
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    if value < node.data
      if node.left == nil
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    elsif value > node.data
      if node.right == nil
        node.right = Node.new(value)
      else
        insert(value, node.right)
      end
    else
      puts 'Value already exists in the tree'
    end
  end

  def traverse(node = @root, array = [])
    return array.push(node) if node.left == nil && node.right == nil

    array = traverse(node.left, array) if node.left != nil
    array.push(node)
    array = traverse(node.right, array) if node.right != nil
    array
  end

  def delete(value, node = self.root)
    if node == self.root && self.root.data == value
      if node.left == nil && node.right == nil
        self.root = nil
      elsif node.left != nil && node.right == nil
        self.root = node.left
      elsif node.left == nil && node.right != nil
        self.root = node.right
      else
        array = traverse(node.right)
        i = 0
        i += 1 until array[i].data > node.data
        node.data = array[i].data
        delete(array[i].data, node.right)
      end
    elsif node == nil || node.left == nil && node.right == nil
      return
    elsif node.left != nil && node.left.data == value
      if node.left.left == nil && node.left.right == nil
        node.left = nil
      elsif node.left.left == nil && node.left.right != nil
        node.left = node.left.right
      elsif node.left.left != nil && node.left.right == nil
        node.left = node.left.left
      else
        array = traverse(node.left.right)
        i = 0
        i += 1 until array[i].data > node.left.data
        node.left.data = array[i].data
        delete(array[i].data, node.left)
      end
      return
    elsif node.right != nil && node.right.data == value
      if node.right.left == nil && node.right.right == nil
        node.right = nil
      elsif node.right.left == nil && node.right.right != nil
        node.right = node.right.right
      elsif node.right.left != nil && node.right.right == nil
        node.right = node.right.left
      else
        array = traverse(node.right.right)
        i = 0
        i += 1 until array[i].data > node.right.data
        node.right.data = array[i].data
        delete(array[i].data, node.right)
      end
      return
    else
      delete(value, node.left)
      delete(value, node.right)
    end
  end

  def find(value)
    array = self.traverse
    array.each do |element|
      return element if element.data == value
    end
    return 'Value not found in the tree'
  end

  def level_order_recursion(node = @root, queue = [@root], array = [@root.data], &block)
    block.call(node) if block_given?

    if node.left != nil
      queue.push(node.left)
      array.push(node.left.data)
    end
    if node.right != nil
      queue.push(node.right)
      array.push(node.right.data)
    end
    queue.shift
    if queue.length == 0
      return array
    else
      return level_order_recursion(queue[0], queue, array, &block)
    end
  end

  def level_order_iteration
    nodes = []
    queue = [self.root]
    while queue.length > 0
      queue.push(queue[0].left) if queue[0].left != nil
      queue.push(queue[0].right) if queue[0].right != nil
      nodes.push(queue[0])
      queue.shift
    end
    if block_given?
      nodes.each {|node| yield node}
    else
      return nodes.map {|node| node.data}
    end
  end

  def inorder(node = @root, array = [], &block)
    array = inorder(node.left, array, &block) if node.left != nil
    if block_given?
      yield node
    else
      array.push(node.data)
    end
    array = inorder(node.right, array, &block) if node.right != nil
    return array
  end

  def preorder(node = @root, array = [], &block)
    if block_given?
      yield node
    else
      array.push(node.data)
    end
    array = preorder(node.left, array, &block) if node.left != nil
    array = preorder(node.right, array, &block) if node.right != nil
    return array
  end

  def postorder(node = @root, array = [], &block)
    array = postorder(node.left, array, &block) if node.left != nil
    array = postorder(node.right, array, &block) if node.right != nil
    if block_given?
      yield node
    else
      array.push(node.data)
    end
    return array
  end

  def height(node, height = 0, levels = [])
    height += 1
    levels.push(height)
    levels = height(node.left, height, levels) if node.left != nil
    levels = height(node.right, height, levels) if node.right != nil
    if height == 1
      return levels.max - 1
    else
      return levels
    end
  end

  def depth(target, node = @root, path = [])
    if node == target
      path.push(node)
      if node == @root
        return path.length - 1
      else
        return path
      end
    else
      path = depth(target, node.left, path) if node.left != nil && path.length == 0
      path = depth(target, node.right, path) if node.right != nil && path.length == 0
    end
    if path.length > 0
      path.push(node)
      if node == @root
        return path.length - 1
      else
        return path
      end
    end
    return path
  end

  def balanced?(node = @root, balanced = true)
    if node.left == nil
      left_height = -1
    else
      left_height = height(node.left)
    end
    if node.right == nil
      right_height = -1
    else
      right_height = height(node.right)
    end
    return false if (left_height - right_height).abs > 1

    balanced = balanced?(node.left, balanced) if node.left != nil && balanced == true
    balanced = balanced?(node.right, balanced) if node.right != nil && balanced == true
    balanced
  end

  def rebalance
    Tree.new(self.inorder)
  end
end