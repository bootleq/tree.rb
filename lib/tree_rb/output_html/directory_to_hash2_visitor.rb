# -*- coding: utf-8 -*-

module TreeRb

#{
# "name": "flare",
# "children": [
#  {
#   "name": "analytics1",
#   "children": [
#    {
#     "name": "cluster",
#     "children": [
#      {"name": "AgglomerativeCluster", "size": 3938},
#      {"name": "CommunityStructure", "size": 3812},
#      {"name": "HierarchicalCluster", "size": 6714},
#      {"name": "MergeEdge", "size": 743}
#     ]
#    },
#    {
#     "name": "graph",
#     "children": [
#      {"name": "BetweennessCentrality", "size": 3534},
#      {"name": "LinkDistance", "size": 5731},
#      {"name": "MaxFlowMinCut", "size": 7840},
#      {"name": "ShortestPaths", "size": 5914},
#      {"name": "SpanningTree", "size": 3416}
#     ]
#    },
#    {
#     "name": "optimization",
#     "children": [
#      {"name": "AspectRatioBanker", "size": 7074}
#     ]
#    }
#   ]
#  },
#  {
#   "name": "animate",
#   "children": [
#    {"name": "Easing", "size": 17010},
#    {"name": "FunctionSequence", "size": 5842},
#    {
#     "name": "interpolate",
#     "children": [
#      {"name": "ArrayInterpolator", "size": 1983},
#      {"name": "ColorInterpolator", "size": 2047},
#      {"name": "DateInterpolator", "size": 1375},
#      {"name": "Interpolator", "size": 8746},
#      {"name": "MatrixInterpolator", "size": 2202},
#      {"name": "NumberInterpolator", "size": 1382},
#      {"name": "ObjectInterpolator", "size": 1629},
#      {"name": "PointInterpolator", "size": 1675},
#      {"name": "RectangleInterpolator", "size": 2042}
#     ]
#    },
#    {"name": "ISchedulable", "size": 1041},
#    {"name": "Parallel", "size": 5176},
#    {"name": "Pause", "size": 449},
#    {"name": "Scheduler", "size": 5593},
#    {"name": "Sequence", "size": 5534},
#    {"name": "Transition", "size": 9201},
#    {"name": "Transitioner", "size": 19975},
#    {"name": "TransitionEvent", "size": 1116},
#    {"name": "Tween", "size": 6006}
#   ]
#  },
#   ]
#  }
# ]
#}
#

#
# Build hash with directory structure
#
  class DirectoryToHash2Visitor < BasicTreeNodeVisitor

    attr_reader :root

    def initialize(pathname)
      @stack = []
    end

    def enter_node(pathname)
      @root = @node if @root.nil?
      @node = { name: File.basename(pathname), children: [] }
      @stack.last[:children] << @node unless @stack.empty?
      @stack.push(@node)
    end

    def exit_node(pathname)
      @node = @stack.pop
    end

    def visit_leaf(pathname)
      begin
        @node[:children] << { name: File.basename(pathname), size: File.stat(pathname).size }
      rescue Errno::ENOENT => e
        $stderr.puts e.to_s
      end
    end

  end
end
