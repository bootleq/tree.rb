# rubygems
require 'rubygems'
require 'abstract'

#
# Classe astratta per visitare un TreeNode
#
class TreeNodeVisitor

  def enter_treeNode( treeNode )
    not_implemented
  end

  def exit_treeNode( treeNode )
    not_implemented
  end

  def visit_leafNode( leafNode )
    not_implemented
  end

end

#
# Utilizzo della classa astratta DirTreeProcessor
# per chimare un blocco su tutti i TreeNode
#
class BlockTreeNodeVisitor
  
  def initialize( &action )
    @block = action
  end
 
  def enter_treeNode( treeNode )
    @block.call( treeNode )
  end
 
  def exit_treeNode( treeNode )
  end
  
  def visit_leafNode( leafNode )
    @block.call( leafNode )
  end
  
end

#
# Utilizzo della classa astratta DirTreeProcessor
# per stampare i nodi di un TreeNode
#
class FlatPrintTreeNodeVisitor < TreeNodeVisitor

  def enter_treeNode( treeNode )
    puts treeNode.name
  end

  def exit_treeNode( treeNode )
  end

  def visit_leafNode( leafNode )
    puts leafNode.name
  end

end


class PrintTreeNodeVisitor < TreeNodeVisitor

  def initialize( *args )
    super( *args )
    @depth = 0
  end

  def visit_leafNode( leafNode )
    str = ""
    (0...@depth-1).step {
      str << " |-"
    }
    str << " |  "
    puts str + leafNode.name
  end

  def enter_treeNode( treeNode )

    str = ""
    (0...@depth).step {
      str << " |-"
    }

    if @depth == 0
      puts str + treeNode.name
    else
      puts str + treeNode.name
    end
    @depth += 1
  end

  def exit_treeNode( treeNode )
    @depth -= 1
  end
end


#
#
#
class DepthTreeNodeVisitor < TreeNodeVisitor

  attr_reader :depth
  
  def initialize
    super
    @depth = 0
  end
  
  def enter_treeNode( treeNode )
    @depth += 1
  end

  def exit_treeNode( treeNode )
    @depth -= 1
  end

  def visit_leafNode( leafNode )
  end

end

#
# Esempio
# Clona un TreeNode
#
class CloneTreeNodeVisitor < TreeNodeVisitor
  
  attr_reader :clonedRoot
  
  def initialize
    super
    @clonedRoot = nil
    @stack = []
  end
  
  def enter_treeNode( treeNode )
    if @stack.empty?
      clonedTreeNode = TreeNode.new( treeNode.name )
      @clonedRoot = clonedTreeNode
    else
      clonedTreeNode = TreeNode.new( treeNode.name, @stack.last )
    end
    @stack.push( clonedTreeNode )
  end

  def exit_treeNode( treeNode )
    @stack.pop
  end

  def visit_leafNode( leafNode )
    clonedLeafNode = LeafNode.new( leafNode.name, @stack.last )
  end

end