# A Crystal module to handle [directed acyclic graphs](https://en.wikipedia.org/wiki/Directed_acyclic_graph) (DAG)
#
# This DAG implementation can be used for creating schedulers. E.g.: running multiple tasks which has predefined dependencies.
module DagCr
  VERSION = "0.1.0"

  # Graph class represents a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) with unweighted edges.
  # Graph uses a Hash to store its data. K is a uniqe identifier of a vertex, and V can hold any properties for it.
  #
  # Example:
  # ```
  # dag = )Graph(Int32).new
  # dag.add(4)
  # dag.add(9)
  # dag.add(1)
  # dag.add(2)
  # dag.add(3)
  # dag.add(5)
  # dag.add(6)
  # dag.add(7)
  # dag.add(8)
  # dag.add_edge(1, 3)
  # dag.add_edge(5, 6)
  # dag.add_edge(5, 7)
  # dag.add_edge(6, 4)
  #
  # dag.keys            # => eq([9, 1, 3, 2, 5, 6, 4, 7, 8])
  # dag.successors(5)   # => [6, 7]
  # dag.predecessors(4) # => [6]
  # dag[3]              # => nil
  # ```
  class Graph(T)
    include Enumerable(T)
    # include Iterable(t)

    @vertices = {} of T => Vertex(T)

    # Two graph equals if they have vertices with same ids and the other has an edge between vertices with same ids if the first graph has an edge.
    #
    # Example:
    # ```
    # dag1 = Graph(Int32).new
    # dag1.add(1)
    # dag1.add(3)
    # dag1.add(5)
    # dag1.add_edge(1, 3)
    # dag1.add_edge(5, 3)
    #
    # dag2 = Graph(Int32).new
    # dag2.add(1)
    # dag2.add(3)
    # dag2.add(5)
    # dag2.add_edge(1, 3)
    # dag2.add_edge(5, 3)
    # dag1.should eq(dag2)
    #
    # dag1 == dag2 # => true
    # ```
    def ==(other : Graph(T))
      return false unless size == other.size
      @vertices.each do |value, vertex|
         other.includes? value
        return false unless other.successors(value) == vertex.successors && other.predecessors(value) == vertex.predecessors
      end
      true
    end

    def includes?(v : T)
      @vertices.has_key?(v)
    end

    # Compares with other value. It is allways false.
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag == 1 # => false
    # dag == 2 # => false
    # ```
    def ==(other)
      false
    end

    # Gets the predecessors of a vertex identified by key.
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # dag.add(3)
    # dag.add(4)
    # dag.add(1, 2)
    # dag.add(2, 3)
    # dag.add(2, 4)
    # dag.predecessors(2) # => [1]
    # ```
    def predecessors(value : T)
      @vertices[value].predecessors
    end

    # Gets the successors of a vertex identified by key.
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # dag.add(3)
    # dag.add(4)
    # dag.add(1, 2)
    # dag.add(2, 3)
    # dag.add(2, 4)
    # dag.successors(2) # => [3,4]
    # ```
    def successors(value : T)
      @vertices[value].successors
    end

    # Adds a new vertex to the graph.
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # ```
    def add(v : T)
      @vertices[v] = Vertex(T).new
    end

    # Adds a new edge to graph. If vertices doesn't exists in graph, they are also added.
    # Function raises KeyError if one of the vertices doesn't exists.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1)
    # dag.add(2)
    # dag.add(1, 2)
    # dag.predecessors[2] # => [1]
    # dag.successors[1]   # => [2]
    # ```
    def add_edge(from : T, to : T)
      @vertices[from].successors.push to
      @vertices[to].predecessors.push from
    end

    # Deletes a vertex from graph.
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # dag.add(1, 2)
    # dag.delete(2)
    # dag.keys # => [1]
    # ```
    def delete(v : T)
      @vertices[v].successors.each &.predecessors.delete v
      @vertices[v].predecessors.each &.successors.delete v
      @vertices.delete v
    end

    # Deletes an edge from graph. If there is no edge between *from* and *to*,
    # function will do nothing
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1,)
    # dag.add(2,)
    # dag.add(1, 2)
    # dag.delete(1, 2)
    # ```
    def delete(from : T, to : T)
      @vertices[from].successors.delete to
      @vertices[to].predecessors.delete from
    end

    # Retreives all the root nodes of the graph
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # dag.add(3)
    # dag.add(1, 2)
    # dag.roots # => [1, 3]
    # ```
    def roots
      @vertices.select { |value,vertex| vertex.root? }.map { |value,vertex| value }
    end

    # Calls a given block on every key and value pairs stored in the graph topological order.
    # [Topological order](https://en.wikipedia.org/wiki/Topological_sorting) is computed with Kahn's algorytm. 
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # dag.add(3)
    # dag.add(4)
    # dag.add(1, 3)
    # dag.add(2, 4)
    # dag.each{ |v| v }.to_a # => [1, 2, 3, 4 ]
    # ```
    def each
      sorted, unsorted = topological_sort
      raise CycleDetectedError.new(unsorted.keys) if sorted.size() < @vertices.size()
      sorted.each { |v,_| yield(v) }
    end

    private def topological_sort
      marked = {} of T => Vertex(T)
      unmarked = @vertices.clone
      check_visited( marked, unmarked, roots )
      {marked, unmarked}
    end

    private def check_visited(marked, unmarked, values) 
      values.each do |v|
        vertex = @vertices[v]
        if vertex.predecessors.all? { |p| marked.has_key? p }
          marked[v] = vertex
          unmarked.delete v
          check_visited marked, unmarked, vertex.successors
        end
      end
    end

    # Validate a graph, whether it is acyclic.
    # 
    # Example:
    # ```
    # dag = )Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # dag.add(3)
    # dag.add(4)
    # dag.add_edge(1, 2)
    # dag.add_edge(2, 3)
    # dag.add_edge(3, 4)
    # dag.valid? # => true
    # dag.add_edge(4, 2)        
    # dag.valid? # => false
    # ```
    def valid?
      sorted, _unsorted = topological_sort
      sorted.size == @vertices.size
    end
  end

  # Raised when a graph is cyclic.
  #
  # If a cycle is detected, this error will be risen with the key of the vertex found twice in a going-over.
  class CycleDetectedError < Exception

    # Key will be the key of vertex found twice in a going-over of graph.
    def initialize(v)
      super("Cycle detected in graph with keys #{v}")
    end
  end

  private class Vertex(T)
    property predecessors = [] of T
    property successors = [] of T

    def initialize()
    end

    def ==(other : Vertex(T))
      @predecessors == other.predecessors && @successors == other.successors
    end

    def clone
      v = Vertex(T).new 
      v.predecessors = @predecessors.clone
      v.successors = @successors.clone
      v
    end

    def root?
      predecessors.empty?
    end
  end
end
