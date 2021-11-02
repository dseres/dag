module Dag
  VERSION = "0.1.0"

  # Graph class represents a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) with unweighted edges.
  # Graph is represented as adjecency list of its vertices. Graph uses a Hash(V) storing its elements. V must be a uniqe value
  # identifying a vertex of graph.
  #
  # Example:
  # ```
  # dag = Dag::Graph(Int32).new
  # dag.add 1, 2, 3, 4, 5
  # dag.add_edge({1, 3}, {1, 2}, {3, 4})
  # ```
  class Graph(V)
    include Enumerable(V)
    include Iterable(V)

    @vertices = {} of V => Adjacency(V)

    # Adds a new vertex to the graph.
    # If vertex is already exists function will raise VertexExistsError
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add 1
    # dag.add 2
    # dag.to_a # => [1,2]
    # ```
    def add(vertex : V)
      raise VertexExistsError.new(vertex) if has?(vertex)
      @vertices[vertex] = Adjacency(V).new
    end

    # :ditto:
    def add(*vertices : V)
      vertices.each { |vertex| add vertex }
    end

    # Checks whether a vertex exists in graph
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add 1
    # dag.add 2
    # dag.has? 1 # => true
    # dag.has? 2 # => true
    # dag.has? 3 # => false
    # ```
    def has?(vertex : V)
      @vertices.has_key?(vertex)
    end

    # Adds a new edge to graph.
    # Function will insert vertex too if one of the vertices doesn't exists.
    # If edge is already exists it will not add it again.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add_edge 1, 2
    # dag.to_a           # => [1, 2]
    # dag.has_edge? 1, 2 # => true
    # ```
    def add_edge(from : V, to : V)
      add from unless has? from
      add to unless has? to
      return if has_edge? from, to
      @vertices[from].successors.push to
      @vertices[to].predecessors.push from
    end

    # :ditto:
    def add_edge(edge : Tuple(V, V))
      add_edge(edge[0], edge[1])
    end

    # :ditto:
    def add_edge(*edges : Tuple(V, V))
      edges.each { |edge| add_edge edge }
    end

    # Checks whether an edge exists.
    # Raises VertexNotExistsError when one of the vertices doesn't exists.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add_edge 1, 2
    # dag.has_edge? 1, 2 # => true
    # ```
    def has_edge?(from : V, to : V)
      raise VertexNotExistsError.new from unless has? from
      raise VertexNotExistsError.new to unless has? to
      @vertices[from].has_successor?(to) && @vertices[to].has_predecessor?(from)
    end

    # Two graph equals if they have vertices with same ids and the other has an edge between vertices with same ids if the first graph has an edge.
    #
    # Example:
    # ```
    # dag1 = Dag::Graph(Int32).new
    # dag1.add 1
    # dag1.add 3
    # dag1.add 5
    # dag1.add_edge 1, 3
    # dag1.add_edge 5, 3
    #
    # dag2 = Dag::Graph(Int32).new
    # dag2.add 1
    # dag2.add 3
    # dag2.add 5
    # dag2.add_edge 1, 3
    # dag2.add_edge 5, 3
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

    # Compares with other vertex. It is allways false.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
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
    # dag = Dag::Graph(Int32).new
    # dag.add 1, 2, 3, 4
    # dag.add_edge({1, 2}, {2, 3}, {2, 4})
    # dag.predecessors 2 # => [1]
    # ```
    def predecessors(vertex : V)
      @vertices[vertex].predecessors
    end

    # Gets the successors of a vertex identified by key.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add 1, 2, 3, 4
    # dag.add_edge({1, 2}, {2, 3}, {2, 4})
    # dag.successors(2) # => [3,4]
    # ```
    def successors(vertex : V)
      @vertices[vertex].successors
    end

    # Deletes a vertex from graph.
    # Raises VertexNotExistsError when *vertex* doesn't exists in graph.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add 1
    # dag.add 2
    # dag.add_edge 1, 2
    # dag.delete 2
    # dag.has? 2 # => false
    # ```
    def delete(vertex : V)
      raise VertexNotExistsError.new vertex unless has? vertex
      @vertices[vertex].successors.each { |s| @vertices[s].predecessors.delete vertex }
      @vertices[vertex].predecessors.each { |p| @vertices[p].successors.delete vertex }
      @vertices.delete vertex
    end

    # Deletes an edge from graph. If one of the vertices doesn't exists, function will raise VertexNotExistsError.
    # If edge doesn't exists, function will do nothing.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add 1
    # dag.add 2
    # dag.add_edge 1, 2
    # dag.delete_edge 1, 2
    # ```
    def delete_edge(from : V, to : V)
      raise VertexNotExistsError.new from unless has? from
      raise VertexNotExistsError.new to unless has? to
      return unless has_edge? from, to
      @vertices[from].successors.delete to
      @vertices[to].predecessors.delete from
    end

    # Retreives all the root vertices of the graph
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add 1, 2, 3
    # dag.add_edge 1, 2
    # dag.roots # => [1, 3]
    # ```
    def roots
      @vertices.select { |_vertex, adjacency| adjacency.root? }.map { |vertex, _adjacency| vertex }
    end

    # Calls a given block on every key and vertex pairs stored in the graph topological order.
    # [Topological order](https://en.wikipedia.org/wiki/Topological_sorting) is computed with Kahn's algorytm.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # dag.add(1, 2, 3, 4)
    # dag.add_edge({1, 2}, {3, 4})
    # dag.each { |v| p! v }
    # dag.to_a # => [1, 2, 3, 4 ]
    # ```
    def each
      sorted, unsorted = topological_sort
      raise CycleDetectedError.new(unsorted.keys) if sorted.size < @vertices.size
      sorted.each { |vertex, _| yield(vertex) }
    end

    private def topological_sort
      marked = {} of V => Adjacency(V)
      unmarked = @vertices.dup
      check_visited(marked, unmarked, roots)
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
    # dag = Dag::Graph(Int32).new
    # dag.add 1, 2, 3, 4
    # dag.add_edge({1, 2}, {2, 3}, {3, 4})
    # dag.valid? # => true
    # dag.add_edge(4, 2)
    # dag.valid? # => false
    # ```
    def valid?
      sorted, _unsorted = topological_sort
      sorted.size == @vertices.size
    end

    # Retreives an iterator of the graph. The iterator will retreive vertices
    # in topological order.
    #
    # Example:
    # ```
    # dag = Dag::Graph(Int32).new
    # (1...10).each { |i| dag.add i }
    # dag.add_edge({1, 3}, {5, 9}, {8, 7}, {8, 6}, {6, 4}, {4, 3}, {4, 7})
    # dag.each.size.should eq 9
    # dag.each.to_a.should eq [1, 2, 5, 8, 9, 6, 4, 3, 7]
    # ```
    def each : Iterator(V)
      GraphIterator(V).new(self)
    end

    private class GraphIterator(V)
      include Iterator(V)

      @graph : Graph(V)
      @visited = Set(V).new
      @vertices_to_check : Array(V)

      def initialize(@graph)
        @vertices_to_check = graph.roots
      end

      def next
        next_vertex = find_next
        if !next_vertex.nil?
          @visited.add next_vertex
          @vertices_to_check.delete next_vertex
          @graph.successors(next_vertex).each { |successors| @vertices_to_check.push successors }
          return next_vertex
        end
        raise CycleDetectedError.new(@vertices_to_check) unless @vertices_to_check.empty?
        stop
      end

      private def find_next
        @vertices_to_check.find do |vertex|
          @graph.predecessors(vertex).all? do |predecessor|
            @visited.includes? predecessor
          end
        end
      end
    end
  end

  # Raised when someone is adding a vertex to the graph but the vertex is almost presented.
  class VertexExistsError < Exception
    def initialize(vertex)
      super("Vertex (#{vertex}) is already exists in graph.")
    end
  end

  # Raised when someone is deleting a vertex which is not presented in graph.
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

    def root?
      predecessors.empty?
    end

    def has_successor?(vertex : V)
      !@successors.index(vertex).nil?
    end

    def has_predecessor?(vertex : V)
      !@predecessors.index(vertex).nil?
    end
  end
end
