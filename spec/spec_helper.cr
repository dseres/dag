require "spec"
require "../src/dag_cr"

def create_test_graph
    dag = Graph(Int32).new 
    dag.add(4)
    dag.add(9)
    dag.add(1)
    dag.add(2)
    dag.add(3)
    dag.add(5)
    dag.add(7)
    dag.add(6)
    dag.add(8)
    dag.add_edge(1, 3)
    dag.add_edge(5, 6)
    dag.add_edge(5, 7)
    dag.add_edge(6, 4)
    dag.add_edge(4, 7)
    dag
end