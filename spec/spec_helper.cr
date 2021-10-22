require "spec"
require "../src/dag_cr"

def create_test_graph
    dag = DagCr::Graph(Int32, Nil).new 
    dag.add(4, nil)
    dag.add(9, nil)
    dag.add(1, nil)
    dag.add(2, nil)
    dag.add(3, nil)
    dag.add(5, nil)
    dag.add(7, nil)
    dag.add(6, nil)
    dag.add(8, nil)
    dag.add_edge(1, 3)
    dag.add_edge(5, 6)
    dag.add_edge(5, 7)
    dag.add_edge(6, 4)
    dag.add_edge(4, 7)
    dag
end