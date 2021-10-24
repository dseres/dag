require "spec"
require "../src/dag_cr"

def create_test_graph
    dag = Graph(Int32).new 
    (1...10).each { |i| dag.add i}
    dag.add_edge(1, 3)
    dag.add_edge(5, 9)
    dag.add_edge(8, 7)
    dag.add_edge(8, 6)
    dag.add_edge(6, 4)
    dag.add_edge(4, 3)
    dag.add_edge(4, 7)
    dag
end