# -*- coding: utf-8 -*-

#
# std lib
#
require 'pathname'
require 'yaml'

#
# rubygems
#
# require 'rubygems' # rubygems must be loaded from binary file to not modify $LOAD_PATH
require 'json'

#
# treevisitor
#

require "treevisitor/version"
require "treevisitor/abs_node"
require 'treevisitor/leaf_node'
require 'treevisitor/tree_node'
require 'treevisitor/basic_tree_node_visitor'
require 'treevisitor/tree_node_visitor'

require 'treevisitor/directory_walker'

#
# visitors
#
require 'treevisitor/visitors/block_tree_node_visitor'
require 'treevisitor/visitors/build_dir_tree_visitor'
require 'treevisitor/visitors/callback_tree_node_visitor2'
require 'treevisitor/visitors/clone_tree_node_visitor'
require 'treevisitor/visitors/depth_tree_node_visitor'
require 'treevisitor/visitors/print_dir_tree_visitor'
require 'treevisitor/visitors/directory_to_hash_visitor'

require 'treevisitor/util/dir_processor'
