# stdlib
require "test/unit"

# common
$COMMON_HOME = File.expand_path( File.join( File.dirname( __FILE__), "..") )
$:.unshift( File.join($COMMON_HOME, "lib" ) )
$:.unshift( File.join($COMMON_HOME, "test" ) )

require "tree_visitor"
require "tree_visitor/tc_tree_node"
require "tree_visitor/tc_tree_node_visitor"
require "tree_visitor/tc_dir_tree_walker"
# require "common/tc_dir_processor"
