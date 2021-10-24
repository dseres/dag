# A Crystal module to handle [directed acyclic graphs](https://en.wikipedia.org/wiki/Directed_acyclic_graph) (DAG)
#
# This DAG implementation can be used for creating schedulers. E.g.: running multiple tasks which has predefined dependencies.
module DagCr
  VERSION = "0.1.0"

  # Graph class represents a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) with unweighted edges.
  # Graph is represented as adjecency list of its vertices. Graph uses a Hash(V) storing its elements. V must be a uniqe value
  # identifying a vertex of graph. 
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
  class Graph(V)
    include Enumerable(V)
    # include Iterable(t)

    @vertices = {} of V => Adjacency(V)

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
    def ==(other : Graph(V))
      return false unless size == other.size
      @vertices.each do |vertex, adjacency|
         other.has? vertex
        return false unless other.successors(vertex) == adjacency.successors && other.predecessors(vertex) == adjacency.predecessors
      end
      true
    end

    def has?(vertex : V)
      @vertices.has_key?(vertex)
    end

    # Compares with other vertex. It is allways false.
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
    def predecessors(vertex : V)
      @vertices[vertex].predecessors
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
    def successors(vertex : V)
      @vertices[vertex].successors
    end

    # Adds a new vertex to the graph.
    #
    # Example:
    # ```
    # dag = Graph(Int32).new
    # dag.add(1)
    # dag.add(2)
    # ```
    def add(vertex : V)
      raise VertexExistsError.new(vertex) if has?(vertex)
      @vertices[vertex] = Adjacency(V).new
    end

    def has_edge?(from : V, to : V)
      @vertices[from].has_successor?(to) && @vertices[to].has_predecessor?(from)
    end

    # Adds a new edge to graph.
    # Function will insert vertex too if one of the vertices doesn't exists.
    # If edge is already exists it will not add it again.
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
    def add_edge(from : V, to : V)
      add from unless has? from
      add to unless has? to
      return if has_edge? from, to
      @vertices[from].successors.push to
      @vertices[to].predecessors.push from
    end

    # Deletes a vertex from graph.
    # Raises VertexNotExistsError when *vertex* doesn't exists in graph.
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
    def delete(vertex : V)
      raise VertexNotExistsError.new vertex unless has? vertex
      @vertices[vertex].successors.each &.predecessors.delete vertex
      @vertices[vertex].predecessors.each &.successors.delete vertex
      @vertices.delete vertex
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
    def delete(from : V, to : V)
      return unless has_edge? from, to
      @vertices[from].successors.delete to
      @vertices[to].predecessors.delete from
    end

    # Retreives all the root vertices of the graph
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
      @vertices.select { |vertex,adjacency| adjacency.root? }.map { |vertex,adjacency| vertex }
    end

    # Calls a given block on every key and vertex pairs stored in the graph topological order.
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
      sorted.each { |vertex,_| yield(vertex) }
    end

    private def topological_sort
      marked = {} of V => Adjacency(V)
      unmarked = @vertices.clone
      check_visited( marked, unmarked, roots )
      {marked, unmarked}
    end

    private def check_visited(marked, unmarked, vertices_to_check) 
      vertices_to_check.each do |vertex|
        adjacency = @vertices[vertex]
        if adjacency.predecessors.all? { |p| marked.has_key? p }
          marked[vertex] = adjacency
          unmarked.delete vertex
          check_visited marked, unmarked, adjacency.successors
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

  class VertexExistsError < Exception
    def initialize(vertex)
      super("Vertex (#{vertex}) is already exists in graph.")
    end
  end

  class VertexNotExistsError < Exception
    def initialize(vertex)
      super("Vertex (#{vertex}) doesn't exists in graph.")
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

  private class Adjacency(V)
    property predecessors = [] of V
    property successors = [] of V

    def ==(other : Adjacency(V))
      @predecessors == other.predecessors && @successors == other.successors
    end

    def clone
      v = Adjacency(V).new 
      v.predecessors = @predecessors.clone
      v.successors = @successors.clone
      v
    end

    def root?
      predecessors.empty?
    end

    def has_successor? (vertex : V)
      !@successors.index(vertex).nil?
    end

    def has_predecessor? (vertex : V)
      !@predecessors.index(vertex).nil?
    end

  end
end
