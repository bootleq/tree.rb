module TreeVisitor
  #
  # Print for every node the name
  #
  class FlatPrintTreeNodeVisitor < TreeNodeVisitor

    def enter_tree_node( tree_node )
      puts tree_node.name
    end

    def exit_tree_node( tree_node )
    end

    def visit_leaf_node( leaf_node )
      puts leaf_node.name
    end

  end
end
