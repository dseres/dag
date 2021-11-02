require "./spec_helper"

include Dag

describe Dag do
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
        dag2.add_edge(9, 10)
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

      it "#add function can add multiple vertices to graph" do
        dag = Graph(Int32).new
        dag.add(1, 2, 3, 4, 5)
        dag.size.should eq 5
      end
    end

    describe "#add_edge" do
      it "Adding an edge should modifiy the sucessors and predecessors of edges" do
        dag = Graph(Int32).new
        dag.add(1)
        dag.add(2)
        dag.add_edge(1, 2)
        dag.predecessors(2).should eq([1])
        dag.successors(1).should eq([2])
      end

      it "Adding edges will create vertices if they don't exists." do
        dag = Graph(Int32).new
        dag.add_edge 2, 3
        dag.add_edge 1, 2
        dag.add_edge 3, 4
        dag.size.should eq 4
      end

      it "#add_edge can add edge as a tuple." do
        dag = Graph(Int32).new
        dag.add_edge({1, 2})
        dag.add_edge({1, 3})
        dag.add_edge({2, 3})
        dag.size.should eq 3
      end

      it "#add_edge can add multiple edges too." do
        dag = Graph(Int32).new
        dag.add_edge({1, 2}, {1, 3}, {2, 3})
        dag.size.should eq 3
      end
    end

    describe "#has?" do
      it "Checking vertices existing or not" do
        dag = create_test_graph
        dag.has?(8).should be_true
        dag.has?(-1).should_not be_true
      end
    end

    describe "#has_edge?" do
      dag = create_test_graph
      it "Checking edges existing or not" do
        dag.has_edge?(8, 6).should be_true
        dag.has_edge?(6, 4).should be_true
        dag.has_edge?(2, 3).should_not be_true
        dag.has_edge?(1, 2).should_not be_true
      end
      it "Checking edges between non-existent vertices should raise error" do
        expect_raises VertexNotExistsError do
          dag.has_edge? -1, -2
        end
        expect_raises VertexNotExistsError do
          dag.has_edge? 1, -1
        end
        expect_raises VertexNotExistsError do
          dag.has_edge? -1, 1
        end
      end
    end

    describe "#predecessors" do
      it "#predecessors should give back predecessors of vertex in order of edge creation" do
        dag = create_test_graph
        dag.predecessors(4).should eq [6]
        dag.predecessors(7).should eq [8, 4]
        dag.predecessors(2).empty?.should be_true
      end
    end

    describe "#successors" do
      it "#successors should give back successors of a vertex in order of edge creation" do
        dag = create_test_graph
        dag.successors(4).should eq [3, 7]
        dag.successors(8).should eq [7, 6]
        dag.successors(2).empty?.should be_true
      end
    end

    describe "#delete" do
      it "Vertex should be deleted." do
        dag = create_test_graph
        dag.delete 2
        dag.delete 6
        dag.has?(2).should_not be_true
        dag.has?(6).should_not be_true
        dag.has?(4).should be_true
      end
      it "Deleting nonexistent vertices should raise error" do
        dag = create_test_graph
        expect_raises VertexNotExistsError do
          dag.delete -1
        end
      end
    end

    describe "#delete_edge" do
      it "Edges should be deleted." do
        dag = create_test_graph
        dag.delete_edge 4, 7
        dag.has_edge?(4, 7).should_not be_true
      end
      it "Nonexistent edges should be not removed." do
        dag = create_test_graph
        dag.has_edge?(7, 2).should_not be_true
        dag.delete_edge 7, 2
        dag.has_edge?(7, 2).should_not be_true
        dag.delete_edge 2, 2
        dag.has_edge?(2, 2).should_not be_true
      end
      it "Removing edges between non-existent vertices should raise an error." do
        dag = create_test_graph
        expect_raises VertexNotExistsError do
          dag.delete_edge -1, -1
        end
        expect_raises VertexNotExistsError do
          dag.delete_edge -1, 1
        end
        expect_raises VertexNotExistsError do
          dag.delete_edge 1, -1
        end
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
        dag.roots.should eq [1, 2, 3, 4, 5, 6, 7, 8, 9]
      end
      it "Graph of three vertices and one edge will have two roots" do
        dag = Graph(Int32).new
        dag.add 1
        dag.add 2
        dag.add 3
        dag.add_edge 1, 2
        dag.roots.size.should eq 2
        dag.roots.should eq [1, 3]
      end
    end

    describe "#valid?" do
      it "Cycles should be detected." do
        dag = create_test_graph
        dag.add_edge(3, 6)
        dag.valid?.should_not be_true
        dag.delete_edge 3, 6
        dag.valid?.should be_true
        dag.add_edge 2, 2
        dag.valid?.should_not be_true
      end
    end

    describe "#each" do
      it "each should give back vertices in topological order" do
        dag = create_test_graph
        dag.size.should eq 9
        dag.to_a.should eq [1, 2, 5, 9, 8, 6, 4, 3, 7]
      end
      it "each should raise an error if cycle is detected" do
        dag = create_test_graph
        dag.add_edge 3, 2
        dag.add_edge 2, 8
        expect_raises CycleDetectedError do
          dag.each { |v| v }
        end
      end

      it "#each : Iterator(V) should give back vertices in topological order" do
        dag = create_test_graph
        dag.each.size.should eq 9
        dag.each.to_a.should eq [1, 2, 5, 8, 9, 6, 4, 3, 7]
      end

      it "iterator should raise an error if cycle is detected" do
        dag = create_test_graph
        dag.add_edge 3, 2
        dag.add_edge 2, 8
        expect_raises CycleDetectedError do
          dag.each.size
        end
      end
    end
  end
end
