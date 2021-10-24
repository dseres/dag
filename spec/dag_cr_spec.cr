require "./spec_helper"

alias Graph=DagCr::Graph 

describe DagCr do
  describe Graph do
    describe "#new" do
      it "A new Graph should contain no element" do
        dag = Graph(String).new
        dag.empty?.should be_true
      end
    end

    describe "#==" do
      it "Two graph having the same vertices and edges shoud be equal" do
        dag1 = create_test_graph
        dag2 = create_test_graph
        dag1.should eq(dag2)

        dag2.add(10)
        dag1.should_not eq(dag2)
        dag1.add(10)
        dag1.should eq(dag2)
        dag2.add_edge(9,10)
        dag1.should_not eq(dag2)

        dag3 = Graph(Int32).new
        dag3.should_not eq(dag1)
      end

      it "A graph and any other value should never be equal" do
        dag = Graph(Int32).new
        dag.add(1)
        dag.should_not eq(1)
        dag.should_not eq("one")
      end
    end

    describe "#add" do
      it "Some added element should be stored in a hashmap" do
        dag = Graph(String).new
        dag.add("one")
        dag.add("two")
        dag.add("three")
        size = dag.size
        size.should eq(3)
      end
    end

    describe "#add_edge" do
      it "Adding an edge should modifiy the sucessors and predecessors of edges" do
        dag = Graph(Int32).new
        dag.add(1)
        dag.add(2)
        dag.add_edge(1,2)
        dag.predecessors(2).should eq( [1] )
        dag.successors(1).should eq( [2] )
      end
    end

    describe "#root" do
      it "Root gives empty array for empty graph" do
        dag = Graph(Int32).new
        dag.roots.empty?.should be_true
      end
      it "If only vertices are added to graph, every vertices will be a root." do
        dag = Graph(Int32).new
        (1..9).each { |i| dag.add i }
        dag.roots.size.should eq 9
        dag.roots.should eq (1..9).to_a
      end
      it "Graph of three vertices and one edge will have two roots" do
        dag = Graph(Int32).new
        dag.add 1
        dag.add 2
        dag.add 3
        dag.add_edge 1,2
        dag.roots.size.should eq 2
        dag.roots.should eq [1,3]
      end
    end

    describe "#valid?" do
      it "Cycles should be detected." do
        dag = create_test_graph
        dag.valid?.should be_true
        dag.add_edge(3, 6)        
        dag.valid?.should_not be_true
      end
    end
  end  
end

