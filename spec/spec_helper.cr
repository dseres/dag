require "spec"
require "../src/dag"

def create_test_graph
  dag = Dag::Graph(Int32).new
  (1...10).each { |i| dag.add i }
  dag.add_edge({1, 3}, {5, 9}, {8, 7}, {8, 6}, {6, 4}, {4, 3}, {4, 7})
  dag
end
