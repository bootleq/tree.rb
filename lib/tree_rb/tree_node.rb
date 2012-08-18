# -*- coding: utf-8 -*-
module TreeRb
  #
  # TreeNode can contains other TreeNode (children)
  # and can contains LeafNode (leaves)
  #
  # TreeNode @children -1---n-> TreeNode
  #          @leaves   -1---n-> LeafNode
  #
  # define dsl to create Tree
  #
  # @example
  #   tree = TreeNode.create do
  #     node "root" do
  #       leaf "l1"
  #       node "sub" do
  #         leaf "l3"
  #       end
  #       node "wo leaves"
  #     end
  class TreeNode < AbsNode

    class << self

      # DSL create a root node
      #
      # tree = TreeNode.create do ... end
      #
      # @param [Class] class1  Subclass of TreeNode default TreeNode
      # @param [Class] class2  Subclass of LeafNode default LeafNode
      # @param [Object] block
      def create(class1 = TreeNode, class2 = LeafNode, &block)
        if class1.ancestors.include?(TreeNode) and class2.ancestors.include?(LeafNode)
          @tree_node_class = class1
          @leaf_node_class = class2
        elsif class1.ancestors.include?(LeafNode) and class2 == LeafNode
          @tree_node_class = self
          @leaf_node_class = class1
        end

        if @tree_node_class.nil? || @leaf_node_class.nil?
          raise "Must be specified class derived from TreeNode and LeafNode"
        end

        @scope_stack = []
        class_eval(&block)
      end

      private

      # DSL node add a child to the surrounding node
      # TreeNode.create do
      #   node "..."
      # end
      def node(*args, &block)
        parent_node = @scope_stack.length > 0 ? @scope_stack[-1] : nil
        args << parent_node
        tree_node = @tree_node_class.new(*args)
        @scope_stack.push tree_node
        if block
          if block.arity == 0 || block.arity == -1
            class_eval(&block)
          elsif block.arity == 1
            new_block = Proc.new { block.call(tree_node) }
            class_eval(&new_block)
          else
            raise "block take too much arguments #{block.arity}"
          end
        end
        @scope_stack.pop
      end

      # DSL node add a leaf to the surround node
      # TreeNode.create do
      #   leaf "..."
      # end
      def leaf(*args, &block)
        tree_node = @scope_stack[-1]
        args << tree_node
        leaf_node = @leaf_node_class.new(*args)
        if block
          if block.arity == 0 || block.arity == -1
            class_eval(&block)
          elsif block.arity == 1
            new_block = Proc.new { block.call(leaf_node) }
            class_eval(&new_block)
          else
            raise "block take too much arguments #{block.arity}"
          end
        end
        leaf_node
      end
    end # end class << self

    # leaves of this node
    attr_reader :leaves

    # children i.e. other tree node
    attr_reader :children

    #
    # @param [Object] content of this node
    # @param [Object] parent of this node. If parent is nil, it is a root
    def initialize(content, parent = nil)
      @leaves   = []
      @children = []
      super(content)
      parent.add_child(self) if parent
    end

    #
    # Test if is a root
    #
    # @return [Boolean] true if this node is a root
    def root?
      @parent.nil?
    end

    #
    # invalidate cached info
    # invalidate propagates form parent to children and leaves
    #
    def invalidate
      super
      @children.each { |c| c.invalidate }
      @leaves.each { |l| l.invalidate }
    end

    #
    # @return [FixNum] total number of nodes
    #
    def nr_nodes
      nr = @leaves.length + @children.length
      @children.inject(nr) { |sum, c| sum + c.nr_nodes }
    end

    #
    # @return [FixNum] total number of leaves
    #
    def nr_leaves
      @leaves.length + @children.inject(0) { |sum, child| sum + child.nr_leaves }
    end

    #
    # @return [FixNum] total number of children
    #
    def nr_children
      @children.length + @children.inject(0) { |sum, child| sum + child.nr_children }
    end

    #
    # Add a Leaf
    # @param [LeafNode]
    #
    # @return self
    #
    def add_leaf(leaf)
      return if leaf.parent == self
      if not leaf.parent.nil?
        leaf.remove_from_parent
      end
      leaf.parent = self
      if @leaves.length > 0
        @leaves.last.next = leaf
        leaf.prev         = @leaves.last
      else
        leaf.prev = nil
      end
      leaf.next = nil
      leaf.invalidate
      @leaves << leaf
      self
    end

    #
    # Add a Tree
    # @param [LeafNode]
    #
    # @return self
    #
    def add_child(tree_node)
      return if tree_node.parent == self
      if not tree_node.parent.nil?
        tree_node.remove_from_parent
      else
        tree_node.prefix_path = nil
      end
      tree_node.invalidate
      tree_node.parent = self
      if @children.length > 0
        @children.last.next = tree_node
        tree_node.prev      = @children.last
      else
        tree_node.prev = nil
      end
      tree_node.next = nil
      @children << tree_node
      self
    end

    #
    # Find a node down the hierarchy with content
    # @param [Object,Regexp] content of searched node
    # @return [Object, nil] nil if not found
    #
    def find(content = nil, &block)
      if content and block_given?
        raise "TreeNode::find - passed content AND block"
      end

      if content
        if content.class == Regexp
          block = proc { |l| l.content =~ content }
        else
          block = proc { |l| l.content == content }
        end
      end
      return self if block.call(self)

      leaf = @leaves.find { |l| block.call(l) }
      return leaf if leaf

      @children.each do |child|
        node = child.find &block
        return node if node
      end
      nil
    end

    #
    # return the visitor
    #
    def accept(visitor)
      visitor.enter_node(self)
      @leaves.each do |leaf|
        leaf.accept(visitor)
      end
      @children.each do |child|
        child.accept(visitor)
      end
      visitor.exit_node(self)
      visitor
    end

    #
    # Format the content of tree
    #

    # TODO: integrate with ansi color
    # TODO: see dircolors command
    # http://isthe.com/chongo/tech/comp/ansi_escapes.html

    # puts "\033[2J" # clear screen
    # ESC[K Clear to end of line
    # puts "aaaa \033[7;31;40m ciao \033[0m"


    #
    # check console character encoding
    # altre variabili LC_CTYPE
    # LC_ALL
    # comando locale
    # puts "enconding: #{ENV['LANG']}"
    #


    # │ (ascii 179)
    # ├ (ascii 195)
    # └ (ascii 192)
    # ─ (ascii 196)


    BRANCH      = '|-- '
    LAST_BRANCH = '`-- '
    CONT_1      = "|   "
    CONT_2      = "    "

    def to_str(prefix= "", options = { })
      #TODO: find a more idiomatic mode to assign an array of options
      tty_color        = options[:colorize].nil? ? false : options[:colorize]
      show_indentation = options[:show_indentation].nil? ? true : options[:show_indentation]
      str              = ""

      # print node itself
      if root?
        str << node_content_to_str(content, options)
      else

        if show_indentation
          str << prefix
          if self.next
            str << BRANCH
          else
            str << LAST_BRANCH
          end
        end

        str << node_content_to_str(content, options)
        if show_indentation
          prefix += self.next ? CONT_1 : CONT_2
        end
      end

      # print leaves
      @leaves.each do |leaf|

        if show_indentation
          str << prefix
          if !leaf.next.nil? or !@children.empty?
            str << BRANCH
          else
            str << LAST_BRANCH
          end
        end

        str << leaf_content_to_str(leaf.content, options)
      end

      # print children
      @children.each do |child|
        str << child.to_str(prefix, options)
      end
      str
    end

    def self.method_added(s)
      if s == :to_str
        puts "Warning: you should not override method 'to_str'"
      else
        super
      end
    end

    private

    def node_content_to_str(content, options)
      if options[:tty_color]
        "#{ANSI.red { content.to_str }}\n"
      else
        "#{content.to_str }\n"
      end
    end

    def leaf_content_to_str(content, options)
      if options[:tty_color]
        "#{ANSI.green { content.to_str }}\n"
      else
        "#{content.to_str }\n"
      end
    end


  end # end class
end # end module TreeRb
