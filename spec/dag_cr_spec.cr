require "./spec_helper"

alias Graph=DagCr::Graph 

describe DagCr do
  describe DagCr::Graph do
    describe "#new" do
      it "A new Graph should contain no element" do
        dag = DagCr::Graph(String, Int32).new
        dag.empty?.should be_true
      end
    end

    describe "#==" do
      it "Two graph having the same vertices and edges shoud be equal" do
        dag1 = Graph(Int32, Int32).new
        dag1.add(1,2)
        dag1.add(3,4)
        dag1.add(5,6)
        dag1.add_edge(1,3)
        dag1.add_edge(5,3)
        dag2 = Graph(Int32, Int32).new
        dag2.add(1,2)
        dag2.add(3,4)
        dag2.add(5,6)
        dag2.add_edge(1,3)
        dag2.add_edge(5,3)
        dag1.should eq(dag2)

        dag2.add(7,8)
        dag1.should_not eq(dag2)
        dag1.add(7,8)
        dag1.should eq(dag2)
        dag2.add_edge(7,5)
        dag1.should_not eq(dag2)

        dag3 = Graph(Int32, Int32).new
        dag3.should_not eq(dag1)
        dag3 = Graph(String, Int32).new
        dag3.should_not eq(dag1)
      end

      it "A graph and any other value should never be equal" do
        dag = Graph(Int32, String).new
        dag.add(1, "one")
        dag.should_not eq(1)
        dag.should_not eq("one")
      end

    end

    describe "#[]" do
      it "Indexing of graph with operator [] should give back value or raise a KeyError" do
        dag = Graph(Int32, String).new
        dag.add(1, "value1")
        dag.add(2, "value2")
        dag[1].should eq("value1")
        dag[2].should eq("value2")
        expect_raises(KeyError) do
          dag[3]
        end
      end
    end

    describe "#[]?" do
    it "Indexing of graph with operator []? should give back value or raise a KeyError" do
      dag = Graph(Int32, String).new
      dag.add(1, "value1")
      dag.add(2, "value2")
      dag[1]?.should eq("value1")
      dag[2]?.should eq("value2")
      dag[3]?.should be_nil
    end
  end

    describe "#[]=" do
      it "Assign index operator should give a new value for a key. "  do
        dag = Graph(Int32, String).new
        dag[1] = "value1"
        dag[2] = "value2"
        dag[2] = "val2"
        dag[1].should be("value1")
        dag[2].should be("val2")
      end
    end

    describe "#keys" do
      it "Keys should contains all keys in topological order" do
        dag = DagCr::Graph(Int32, Nil).new
        dag.add(4, nil)
        dag.add(9, nil)
        dag.add(1, nil)
        dag.add(2, nil)
        dag.add(3, nil)
        dag.add(5, nil)
        dag.add(6, nil)
        dag.add(7, nil)
        dag.add(8, nil)
        dag.add_edge(1, 3)
        dag.add_edge(5, 6)
        dag.add_edge(5, 7)
        dag.add_edge(6, 4)
        dag.keys.should eq([9, 1, 3, 2, 5, 6, 4, 7, 8])
      end
    end

    describe "#add" do
      pending "Some added element should be stored in a hashmap" do
        dag = DagCr::Graph(String, Int32).new
        dag.add("one", 1)
        dag.add("two", 2)
        dag.add("three", 3)
        size = dag.size
        size.should eq(3)
      end
    end

    describe "#root" do
      it "Root gives empty array for empty graph" do
        dag = DagCr::Graph(Int32, Int32).new
        dag.roots.empty?.should be_true
      end
      it "If only vertices are added to graph, every vertices will be a root." do
        dag = DagCr::Graph(Int32, Int32).new
        dag.add(1, 1)
        dag.add(2, 2)
        dag.roots.size.should eq(2)
        dag.roots.should eq([{1, 1}, {2, 2}])
      end
      it "Graph of three vertices and one edge will have two roots" do
        dag = DagCr::Graph(Int32, Int32).new
        dag.add(1, 1)
        dag.add(2, 2)
        dag.add(3, 3)
        dag.add_edge(1, 2)
        dag.roots.size.should eq(2)
        dag.roots.should eq([{1, 1}, {3, 3}])
      end
    end

    describe "#valid?" do
      it "Cycles should be detected." do
        dag = DagCr::Graph(Int32, Nil).new
        dag.add(1, nil)
        dag.add(2, nil)
        dag.add(3, nil)
        dag.add(4, nil)
        dag.add_edge(1, 2)
        dag.add_edge(2, 3)
        dag.add_edge(3, 4)
        dag.valid?.should be_true
        dag.add_edge(4, 2)        
        dag.valid?.should_not be_true
      end

      it "Cycles should be detected from a given vertex." do
        dag = DagCr::Graph(Int32, Nil).new
        dag.add(1, nil)
        dag.add(2, nil)
        dag.add(3, nil)
        dag.add(4, nil)
        dag.add_edge(1, 2)
        dag.add_edge(2, 3)
        dag.add_edge(3, 4)
        dag.valid?(3).should be_true
        dag.add_edge(4, 2)        
        dag.valid?(3).should_not be_true
      end
    end
  end

end
