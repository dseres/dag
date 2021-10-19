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
  # dag = DagCr::Graph(Int32, Nil).new
  # dag.add(4, nil)
  # dag.add(9, nil)
  # dag.add(1, nil)
  # dag.add(2, nil)
  # dag.add(3, nil)
  # dag.add(5, nil)
  # dag.add(6, nil)
  # dag.add(7, nil)
  # dag.add(8, nil)
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
  class Graph(K, V)
    include Enumerable({K, V})
    # include Iterable({K, V})

    getter auto_validate
    @vertices = {} of K => Vertex(K, V)

    # Constructor
    #
    # *auto_validate* is an option ( default = false) which turn on auto validation of cycle. 
    # If validation is on, every added edge will trigger a validation whether the graph is acyclic.
    def initialize(@auto_validate = false); end

    # Two graph equals if they have vertices with same ids and the other has an edge between vertices with same ids if the first graph has an edge.
    #
    # Example:
    # ```
    # dag1 = Graph(Int32, Int32).new
    # dag1.add(1, 2)
    # dag1.add(3, 4)
    # dag1.add(5, 6)
    # dag1.add_edge(1, 3)
    # dag1.add_edge(5, 3)
    #
    # dag2 = Graph(Int32, Int32).new
    # dag2.add(1, 2)
    # dag2.add(3, 4)
    # dag2.add(5, 6)
    # dag2.add_edge(1, 3)
    # dag2.add_edge(5, 3)
    # dag1.should eq(dag2)
    #
    # dag1 == dag2 # => true
    # ```
    def ==(other : Graph(K, V))
      return false unless size == other.size
      @vertices.each do |key, vertex|
        other_value = other[key]?
        return false unless other_value && other_value == vertex.value && other.successors(key) == vertex.successors && other.predecessors(key) == vertex.predecessors
      end
      true
    end

    # Compares with other value. It is allways false.
    #
    # Example:
    # ```
    # dag = Graph(Int32, Int32).new
    # dag.add(1, 2)
    # dag == 1 # => false
    # dag == 2 # => false
    # ```
    def ==(other)
      false
    end

    # Returns the value for the key given by key. If not found, returns the default value given by Hash(K,V).new, otherwise raises KeyError.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(2, "value1")
    # dag[1] # => "value2"
    # dag[3] # => raises KeyError
    # ```
    def [](key)
      @vertices[key].value
    end

    # Returns the value for the key given by key. If not found, returns nil.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(2, "value2")
    # dag[1] # => "value1"
    # dag[3] # => nil
    # ```
    def []?(key)
      vertex = @vertices[key]?
      return nil unless vertex
      vertex.value
    end

    # Sets the value of key to the given value. If key doesn't exists insert it.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag[1] = "value1"
    # dag[2] = "value2"
    # dag[1] # => "value1"
    # dag[3] # => nil
    # ```
    def []=(key : K, value : V)
      vertex = @vertices[key]?
      add(key, value) if vertex.nil?
      vertex.value = value unless vertex.nil?
    end

    # Gets the predecessors of a vertex identified by key.
    # Example:
    # ```
    # dag = Graph(Int32, Nil).new
    # dag.add(1, nil)
    # dag.add(2, nil)
    # dag.add(3, nil)
    # dag.add(4, nil)
    # dag.add(1, 2)
    # dag.add(2, 3)
    # dag.add(2, 4)
    # dag.predecessors(2) # => [1]
    # ```
    def predecessors(key : K)
      @vertices[key].predecessors
    end

    # Gets the successors of a vertex identified by key.
    #
    # Example:
    # ```
    # dag = Graph(Int32, Nil).new
    # dag.add(1, nil)
    # dag.add(2, nil)
    # dag.add(3, nil)
    # dag.add(4, nil)
    # dag.add(1, 2)
    # dag.add(2, 3)
    # dag.add(2, 4)
    # dag.successors(2) # => [3,4]
    # ```
    def successors(key : K)
      @vertices[key].successors
    end

    # Adds a new vertex to the graph.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(2, "value2")
    # ```
    def add(k : K, p : V)
      @vertices[k] = Vertex(K, V).new(p)
    end

    # Adds a new edge to graph. If vertices doesn't exists in graph, they are also added.
    # Function raises KeyError if one of the vertices doesn't exists.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(2, "value2")
    # dag.add(1, 2)
    # dag.predecessors[2] # => [1]
    # dag.successors[1]   # => [2]
    # ```
    def add_edge(from : K, to : K)
      @vertices[from].successors.push to
      @vertices[to].predecessors.push from
      raise CycleError.new(to) if auto_validate && !valid?(to)
    end

    # Deletes a vertex from graph.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(2, "value2")
    # dag.add(1, 2)
    # dag.delete(2)
    # dag.keys # => [1]
    # ```
    def delete(k : K)
      @vertices[k].successors.each &.predecessors.delete k
      @vertices[k].predecessors.each &.successors.delete k
      @vertices.delete k
    end

    # Deletes an edge from graph. If there is no edge between *from* and *to*,
    # function will do nothing
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(2, "value2")
    # dag.add(1, 2)
    # dag.delete(1, 2)
    # ```
    def delete(from : K, to : K)
      @vertices[from].successors.delete to
      @vertices[to].predecessors.delete from
    end

    # Retreives all the root nodes of the graph
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(2, "value2")
    # dag.add(3, "value3")
    # dag.add(1, 2)
    # dag.roots # => [1, 3]
    # ```
    def roots
      @vertices.select { |_k, vtx| vtx.predecessors.empty? }.map { |k, vtx| {k, vtx.value} }
    end

    # Calls a given block on every key and value pairs stored in the graph topological order.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.each do |key, value|
    #   key   # => 1
    #   value # => value
    # end     #
    #
    # dag.add(2, "value2")
    # dag.add(3, "value3")
    # dag.add(1, 3)
    # dag.each { |key_n_value| key_n_value }.to_a # => [{1, "value"}, {3, "value3"}, {2, "value2"} ]
    # ```
    def each
      keys.each { |k| yield({k, self[k]}) }
    end

    # Returns array of keys in topological order.
    #
    # Example:
    # ```
    # dag = Graph(Int32, String).new
    # dag.add(1, "value1")
    # dag.add(4, "value4")
    # dag.add(2, "value2")
    # dag.add(3, "value3")
    # dag.add(1, 3)
    # dag.add(2, 4)
    # dag.keys # => [1, 3, 2, 4]
    # ```
    def keys
      roots.map { |k, _v| keys_from(k) }.sum([] of K)
    end

    private def keys_from(k) : Array(K)
      @vertices[k].successors.map() { |k| keys_from(k) }.sum([k])
    end

    # Validate a graph, whether it is acyclic.
    # 
    # Example:
    # ```
    # dag = DagCr::Graph(Int32, Nil).new
    # dag.add(1, nil)
    # dag.add(2, nil)
    # dag.add(3, nil)
    # dag.add(4, nil)
    # dag.add_edge(1, 2)
    # dag.add_edge(2, 3)
    # dag.add_edge(3, 4)
    # dag.valid? # => true
    # dag.add_edge(4, 2)        
    # dag.valid? # => false
    # ```
    def valid?
      keys = Set(K).new(@vertices.size)
      valid = true
      roots.each { |k, _v| valid = valid && valid_from?(keys, k) }
      valid
    end

    # Validate subgraph from vertex with key whether it is acyclic.
    # 
    # Example:
    # ```
    # dag = DagCr::Graph(Int32, Nil).new
    # dag.add(1, nil)
    # dag.add(2, nil)
    # dag.add(3, nil)
    # dag.add(4, nil)
    # dag.add_edge(1, 2)
    # dag.add_edge(2, 3)
    # dag.add_edge(3, 4)
    # dag.valid(3)? # => true
    # dag.add_edge(4, 2)        
    # dag.valid(3)? # => false
    # ```
    def valid?(key : K)
      keys = Set(K).new(@vertices.size)
      valid_from?(keys, key)
    end

    private def valid_from?(keys : Set(K), key)
      return false unless keys.add? key
      valid = true
      successors(key).each { |k| valid = valid && valid_from?(keys, k) }
      valid
    end
  end

  # Raised when a graph is cyclic.
  #
  # If a cycle is detected, this error will be risen with the key of the vertex found twice in a going-over.
  class CycleError < Exception

    # Key will be the key of vertex found twice in a going-over of graph.
    def initialize(key)
      super("Cycle detected from key: #{key}")
    end
  end

  private class Vertex(K, V)
    property value : V
    property predecessors = [] of K
    property successors = [] of K

    def initialize(@value : V)
    end

    def ==(other : Vertex(K, V))
      @value == other.value && @predecessors == other.predecessors && successors == other.successors
    end
  end
end
