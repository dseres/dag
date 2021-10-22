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
        dag1 = Graph(Int32).new
        dag1.add(1)
        dag1.add(3)
        dag1.add(5)
        dag1.add_edge(1,3)
        dag1.add_edge(5,3)
        dag2 = Graph(Int32).new
        dag2.add(1)
        dag2.add(3)
        dag2.add(5)
        dag2.add_edge(1,3)
        dag2.add_edge(5,3)
        dag1.should eq(dag2)

        dag2.add(7)
        dag1.should_not eq(dag2)
        dag1.add(7)
        dag1.should eq(dag2)
        dag2.add_edge(7,5)
        dag1.should_not eq(dag2)

        dag3 = Graph(Int32).new
        dag3.should_not eq(dag1)
        dag3 = Graph(String).new
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
        dag.add(1)
        dag.add(2)
        dag.roots.size.should eq(2)
        dag.roots.should eq([1,2])
      end
      it "Graph of three vertices and one edge will have two roots" do
        dag = Graph(Int32).new
        dag.add(1)
        dag.add(2)
        dag.add(3)
        dag.add_edge(1, 2)
        dag.roots.size.should eq(2)
        dag.roots.should eq([1,3])
      end
    end

    describe "#valid?" do
      it "Cycles should be detected." do
        dag = create_test_graph
        dag.valid?.should be_true
        dag.add_edge(4, 6)        
        dag.valid?.should_not be_true
      end
    end
  end  
end

