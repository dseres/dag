crystal_doc_search_index_callback({"repository_name":"dag","body":"# DAG - Directed Acyclic Graph  API\n\n[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?style=flat-square)](https://crystal-lang.org/)\n[![Crystal CI](https://github.com/runcobo/runcobo/actions/workflows/crystal.yml/badge.svg)](https://github.com/dseres/dag/actions/workflows/crystal.yml)\n[![GitHub release](https://img.shields.io/github/release/dseres/dag.svg)](https://github.com/dseres/dag/releases)\n[![api docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://dseres.github.io/dag/)\n\nA [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) (DAG) API written in the [crystal](https://crystal-lang.org/) programming languge.\nThis DAG implementation can be used for creating schedulers. E.g.: running multiple tasks which has predefined dependencies.\n\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     dag:\n       github: dseres/dag\n   ```\n\n2. Run `shards install`\n\n## Usage\n\nCreate a new Graph object. You can add and delete vertices and edges easily. If you enumarate the vertices with the #each method, the enumeration will be topologically sorted. The graph structure uses adjacency lists in the backend (implemented with Hash(K,V)), and you can store any hashable objects in it. \n\n```crystal\nrequire \"dag\"\ndag = Dag::Graph(Int32).new \n(1...10).each { |i| dag.add i}\ndag.add_edge({1, 3} , {5, 9} , {8, 7} , {8, 6} , {6, 4} , {4, 3} , {4, 7})\ndag.successors 4 # => [3,7]\ndag.each { |v| p! v}\ndag.to_a # => [1, 2, 5, 9, 8, 6, 4, 3, 7]\n```\n\n## Contributing\n\n1. Fork it (<https://github.com/your-github-user/dag_cr/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [dseres](https://github.com/dseres) - creator and maintainer\n","program":{"html_id":"dag/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"locations":[],"repository_name":"dag","program":true,"enum":false,"alias":false,"const":false,"types":[{"html_id":"dag/Dag","path":"Dag.html","kind":"module","full_name":"Dag","name":"Dag","abstract":false,"locations":[{"filename":"src/dag.cr","line_number":1,"url":null}],"repository_name":"dag","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"\"0.1.0\""}],"types":[{"html_id":"dag/Dag/CycleDetectedError","path":"Dag/CycleDetectedError.html","kind":"class","full_name":"Dag::CycleDetectedError","name":"CycleDetectedError","abstract":false,"superclass":{"html_id":"dag/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"dag/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"dag/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"dag/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/dag.cr","line_number":351,"url":null}],"repository_name":"dag","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"dag/Dag","kind":"module","full_name":"Dag","name":"Dag"},"doc":"Raised when a graph is cyclic.\n\nIf a cycle is detected, this error will be risen with the key of the vertex found twice in a going-over.","summary":"<p>Raised when a graph is cyclic.</p>","constructors":[{"html_id":"new(v)-class-method","name":"new","doc":"Key will be the key of vertex found twice in a going-over of graph.","summary":"<p>Key will be the key of vertex found twice in a going-over of graph.</p>","abstract":false,"args":[{"name":"v","external_name":"v","restriction":""}],"args_string":"(v)","args_html":"(v)","location":{"filename":"src/dag.cr","line_number":353,"url":null},"def":{"name":"new","args":[{"name":"v","external_name":"v","restriction":""}],"visibility":"Public","body":"_ = allocate\n_.initialize(v)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}]},{"html_id":"dag/Dag/Graph","path":"Dag/Graph.html","kind":"class","full_name":"Dag::Graph(V)","name":"Graph","abstract":false,"superclass":{"html_id":"dag/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"dag/Iterable","kind":"module","full_name":"Iterable","name":"Iterable"},{"html_id":"dag/Enumerable","kind":"module","full_name":"Enumerable","name":"Enumerable"},{"html_id":"dag/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"dag/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/dag.cr","line_number":14,"url":null}],"repository_name":"dag","program":false,"enum":false,"alias":false,"const":false,"included_modules":[{"html_id":"dag/Enumerable","kind":"module","full_name":"Enumerable","name":"Enumerable"},{"html_id":"dag/Iterable","kind":"module","full_name":"Iterable","name":"Iterable"}],"namespace":{"html_id":"dag/Dag","kind":"module","full_name":"Dag","name":"Dag"},"doc":"Graph class represents a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) with unweighted edges.\nGraph is represented as adjecency list of its vertices. Graph uses a Hash(V) storing its elements. V must be a uniqe value\nidentifying a vertex of graph.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1, 2, 3, 4, 5\ndag.add_edge({1, 3}, {1, 2}, {3, 4})\n```","summary":"<p>Graph class represents a <a href=\"https://en.wikipedia.org/wiki/Directed_acyclic_graph\">directed acyclic graph</a> with unweighted edges.</p>","instance_methods":[{"html_id":"==(other:Graph(V))-instance-method","name":"==","doc":"Two graph equals if they have vertices with same ids and the other has an edge between vertices with same ids if the first graph has an edge.\n\nExample:\n```\ndag1 = Dag::Graph(Int32).new\ndag1.add 1\ndag1.add 3\ndag1.add 5\ndag1.add_edge 1, 3\ndag1.add_edge 5, 3\n\ndag2 = Dag::Graph(Int32).new\ndag2.add 1\ndag2.add 3\ndag2.add 5\ndag2.add_edge 1, 3\ndag2.add_edge 5, 3\ndag1.should eq(dag2)\n\ndag1 == dag2 # => true\n```","summary":"<p>Two graph equals if they have vertices with same ids and the other has an edge between vertices with same ids if the first graph has an edge.</p>","abstract":false,"args":[{"name":"other","external_name":"other","restriction":"Graph(V)"}],"args_string":"(other : Graph(V))","args_html":"(other : <a href=\"../Dag/Graph.html\">Graph</a>(V))","location":{"filename":"src/dag.cr","line_number":119,"url":null},"def":{"name":"==","args":[{"name":"other","external_name":"other","restriction":"Graph(V)"}],"visibility":"Public","body":"if size == other.size\nelse\n  return false\nend\n@vertices.each do |vertex, adjacency|\n  other.has?(vertex)\n  if ((other.successors(vertex)) == adjacency.successors) && ((other.predecessors(vertex)) == adjacency.predecessors)\n  else\n    return false\n  end\nend\ntrue\n"}},{"html_id":"==(other)-instance-method","name":"==","doc":"Compares with other vertex. It is allways false.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add(1)\ndag == 1 # => false\ndag == 2 # => false\n```","summary":"<p>Compares with other vertex.</p>","abstract":false,"args":[{"name":"other","external_name":"other","restriction":""}],"args_string":"(other)","args_html":"(other)","location":{"filename":"src/dag.cr","line_number":137,"url":null},"def":{"name":"==","args":[{"name":"other","external_name":"other","restriction":""}],"visibility":"Public","body":"false"}},{"html_id":"add(vertex:V)-instance-method","name":"add","doc":"Adds a new vertex to the graph.\nIf vertex is already exists function will raise VertexExistsError\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1\ndag.add 2\ndag.to_a # => [1,2]\n```","summary":"<p>Adds a new vertex to the graph.</p>","abstract":false,"args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"args_string":"(vertex : V)","args_html":"(vertex : V)","location":{"filename":"src/dag.cr","line_number":29,"url":null},"def":{"name":"add","args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"visibility":"Public","body":"if has?(vertex)\n  raise(VertexExistsError.new(vertex))\nend\n@vertices[vertex] = Adjacency(V).new\n"}},{"html_id":"add(*vertices:V)-instance-method","name":"add","doc":"Adds a new vertex to the graph.\nIf vertex is already exists function will raise VertexExistsError\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1\ndag.add 2\ndag.to_a # => [1,2]\n```","summary":"<p>Adds a new vertex to the graph.</p>","abstract":false,"args":[{"name":"vertices","external_name":"vertices","restriction":"V"}],"args_string":"(*vertices : V)","args_html":"(*vertices : V)","location":{"filename":"src/dag.cr","line_number":35,"url":null},"def":{"name":"add","args":[{"name":"vertices","external_name":"vertices","restriction":"V"}],"splat_index":0,"visibility":"Public","body":"vertices.each do |vertex|\n  add(vertex)\nend"}},{"html_id":"add_edge(from:V,to:V)-instance-method","name":"add_edge","doc":"Adds a new edge to graph.\nFunction will insert vertex too if one of the vertices doesn't exists.\nIf edge is already exists it will not add it again.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add_edge 1, 2\ndag.to_a           # => [1, 2]\ndag.has_edge? 1, 2 # => true\n```","summary":"<p>Adds a new edge to graph.</p>","abstract":false,"args":[{"name":"from","external_name":"from","restriction":"V"},{"name":"to","external_name":"to","restriction":"V"}],"args_string":"(from : V, to : V)","args_html":"(from : V, to : V)","location":{"filename":"src/dag.cr","line_number":65,"url":null},"def":{"name":"add_edge","args":[{"name":"from","external_name":"from","restriction":"V"},{"name":"to","external_name":"to","restriction":"V"}],"visibility":"Public","body":"if has?(from)\nelse\n  add(from)\nend\nif has?(to)\nelse\n  add(to)\nend\nif has_edge?(from, to)\n  return\nend\n@vertices[from].successors.push(to)\n@vertices[to].predecessors.push(from)\n"}},{"html_id":"add_edge(edge:Tuple(V,V))-instance-method","name":"add_edge","doc":"Adds a new edge to graph.\nFunction will insert vertex too if one of the vertices doesn't exists.\nIf edge is already exists it will not add it again.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add_edge 1, 2\ndag.to_a           # => [1, 2]\ndag.has_edge? 1, 2 # => true\n```","summary":"<p>Adds a new edge to graph.</p>","abstract":false,"args":[{"name":"edge","external_name":"edge","restriction":"Tuple(V, V)"}],"args_string":"(edge : Tuple(V, V))","args_html":"(edge : Tuple(V, V))","location":{"filename":"src/dag.cr","line_number":74,"url":null},"def":{"name":"add_edge","args":[{"name":"edge","external_name":"edge","restriction":"Tuple(V, V)"}],"visibility":"Public","body":"add_edge(edge[0], edge[1])"}},{"html_id":"add_edge(*edges:Tuple(V,V))-instance-method","name":"add_edge","doc":"Adds a new edge to graph.\nFunction will insert vertex too if one of the vertices doesn't exists.\nIf edge is already exists it will not add it again.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add_edge 1, 2\ndag.to_a           # => [1, 2]\ndag.has_edge? 1, 2 # => true\n```","summary":"<p>Adds a new edge to graph.</p>","abstract":false,"args":[{"name":"edges","external_name":"edges","restriction":"Tuple(V, V)"}],"args_string":"(*edges : Tuple(V, V))","args_html":"(*edges : Tuple(V, V))","location":{"filename":"src/dag.cr","line_number":79,"url":null},"def":{"name":"add_edge","args":[{"name":"edges","external_name":"edges","restriction":"Tuple(V, V)"}],"splat_index":0,"visibility":"Public","body":"edges.each do |edge|\n  add_edge(edge)\nend"}},{"html_id":"delete(vertex:V)-instance-method","name":"delete","doc":"Deletes a vertex from graph.\nRaises VertexNotExistsError when *vertex* doesn't exists in graph.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1\ndag.add 2\ndag.add_edge 1, 2\ndag.delete 2\ndag.has? 2 # => false\n```","summary":"<p>Deletes a vertex from graph.</p>","abstract":false,"args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"args_string":"(vertex : V)","args_html":"(vertex : V)","location":{"filename":"src/dag.cr","line_number":178,"url":null},"def":{"name":"delete","args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"visibility":"Public","body":"if has?(vertex)\nelse\n  raise(VertexNotExistsError.new(vertex))\nend\n@vertices[vertex].successors.each do |succ|\n  @vertices[succ].predecessors.delete(vertex)\nend\n@vertices[vertex].predecessors.each do |pred|\n  @vertices[pred].successors.delete(vertex)\nend\n@vertices.delete(vertex)\n"}},{"html_id":"delete_edge(from:V,to:V)-instance-method","name":"delete_edge","doc":"Deletes an edge from graph. If one of the vertices doesn't exists, function will raise VertexNotExistsError.\nIf edge doesn't exists, function will do nothing.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1\ndag.add 2\ndag.add_edge 1, 2\ndag.delete_edge 1, 2\n```","summary":"<p>Deletes an edge from graph.</p>","abstract":false,"args":[{"name":"from","external_name":"from","restriction":"V"},{"name":"to","external_name":"to","restriction":"V"}],"args_string":"(from : V, to : V)","args_html":"(from : V, to : V)","location":{"filename":"src/dag.cr","line_number":196,"url":null},"def":{"name":"delete_edge","args":[{"name":"from","external_name":"from","restriction":"V"},{"name":"to","external_name":"to","restriction":"V"}],"visibility":"Public","body":"if has?(from)\nelse\n  raise(VertexNotExistsError.new(from))\nend\nif has?(to)\nelse\n  raise(VertexNotExistsError.new(to))\nend\nif has_edge?(from, to)\nelse\n  return\nend\n@vertices[from].successors.delete(to)\n@vertices[to].predecessors.delete(from)\n"}},{"html_id":"descendant?(v:V,other:V):Bool-instance-method","name":"descendant?","doc":"Check if `other` is a descentant of `v`\n\nIf two vertices, `[a, b]` are topologically sorted, then `a` is not a descendant of `b`.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1, 2, 3, 4, 5\ndag.add_edge({1, 2}, {2, 3}, {3, 4}, {5, 4})\ndag.descendant? 1, 4 # => true\ndag.descendant? 1, 5 # => false\ndag.descendant? 2, 1 # => false\ndag.valid?           # => false\n```","summary":"<p>Check if <code>other</code> is a descentant of <code>v</code></p>","abstract":false,"args":[{"name":"v","external_name":"v","restriction":"V"},{"name":"other","external_name":"other","restriction":"V"}],"args_string":"(v : V, other : V) : Bool","args_html":"(v : V, other : V) : Bool","location":{"filename":"src/dag.cr","line_number":282,"url":null},"def":{"name":"descendant?","args":[{"name":"v","external_name":"v","restriction":"V"},{"name":"other","external_name":"other","restriction":"V"}],"return_type":"Bool","visibility":"Public","body":"@vertices[v].successors.any? do |successor|\n  (successor == other) || (descendant?(successor, other))\nend"}},{"html_id":"each(&)-instance-method","name":"each","doc":"Calls a given block on every key and vertex pairs stored in the graph topological order.\n[Topological order](https://en.wikipedia.org/wiki/Topological_sorting) is computed with Kahn's algorytm.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add(1, 2, 3, 4)\ndag.add_edge({1, 2}, {3, 4})\ndag.each { |v| p! v }\ndag.to_a # => [1, 2, 3, 4 ]\n```","summary":"<p>Calls a given block on every key and vertex pairs stored in the graph topological order.</p>","abstract":false,"location":{"filename":"src/dag.cr","line_number":228,"url":null},"def":{"name":"each","yields":1,"block_arity":1,"visibility":"Public","body":"sorted, unsorted = topological_sort\nif sorted.size < @vertices.size\n  raise(CycleDetectedError.new(unsorted.keys))\nend\nsorted.each do |vertex, _|\n  yield(vertex)\nend\n"}},{"html_id":"each:Iterator(V)-instance-method","name":"each","doc":"Retreives an iterator of the graph. The iterator will retreive vertices\nin topological order.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\n(1...10).each { |i| dag.add i }\ndag.add_edge({1, 3}, {5, 9}, {8, 7}, {8, 6}, {6, 4}, {4, 3}, {4, 7})\ndag.each.size.should eq 9\ndag.each.to_a.should eq [1, 2, 5, 8, 9, 6, 4, 3, 7]\n```","summary":"<p>Retreives an iterator of the graph.</p>","abstract":false,"location":{"filename":"src/dag.cr","line_number":297,"url":null},"def":{"name":"each","return_type":"Iterator(V)","visibility":"Public","body":"GraphIterator(V).new(self)"}},{"html_id":"has?(vertex:V)-instance-method","name":"has?","doc":"Checks whether a vertex exists in graph\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1\ndag.add 2\ndag.has? 1 # => true\ndag.has? 2 # => true\ndag.has? 3 # => false\n```","summary":"<p>Checks whether a vertex exists in graph</p>","abstract":false,"args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"args_string":"(vertex : V)","args_html":"(vertex : V)","location":{"filename":"src/dag.cr","line_number":50,"url":null},"def":{"name":"has?","args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"visibility":"Public","body":"@vertices.has_key?(vertex)"}},{"html_id":"has_edge?(from:V,to:V)-instance-method","name":"has_edge?","doc":"Checks whether an edge exists.\nRaises VertexNotExistsError when one of the vertices doesn't exists.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add_edge 1, 2\ndag.has_edge? 1, 2 # => true\n```","summary":"<p>Checks whether an edge exists.</p>","abstract":false,"args":[{"name":"from","external_name":"from","restriction":"V"},{"name":"to","external_name":"to","restriction":"V"}],"args_string":"(from : V, to : V)","args_html":"(from : V, to : V)","location":{"filename":"src/dag.cr","line_number":92,"url":null},"def":{"name":"has_edge?","args":[{"name":"from","external_name":"from","restriction":"V"},{"name":"to","external_name":"to","restriction":"V"}],"visibility":"Public","body":"if has?(from)\nelse\n  raise(VertexNotExistsError.new(from))\nend\nif has?(to)\nelse\n  raise(VertexNotExistsError.new(to))\nend\n(@vertices[from].has_successor?(to)) && (@vertices[to].has_predecessor?(from))\n"}},{"html_id":"predecessors(vertex:V)-instance-method","name":"predecessors","doc":"Gets the predecessors of a vertex identified by key.\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1, 2, 3, 4\ndag.add_edge({1, 2}, {2, 3}, {2, 4})\ndag.predecessors 2 # => [1]\n```","summary":"<p>Gets the predecessors of a vertex identified by key.</p>","abstract":false,"args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"args_string":"(vertex : V)","args_html":"(vertex : V)","location":{"filename":"src/dag.cr","line_number":149,"url":null},"def":{"name":"predecessors","args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"visibility":"Public","body":"@vertices[vertex].predecessors"}},{"html_id":"roots-instance-method","name":"roots","doc":"Retreives all the root vertices of the graph\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1, 2, 3\ndag.add_edge 1, 2\ndag.roots # => [1, 3]\n```","summary":"<p>Retreives all the root vertices of the graph</p>","abstract":false,"location":{"filename":"src/dag.cr","line_number":213,"url":null},"def":{"name":"roots","visibility":"Public","body":"@vertices.select do |_vertex, adjacency|\n  adjacency.root?\nend.map do |vertex, _adjacency|\n  vertex\nend"}},{"html_id":"successors(vertex:V)-instance-method","name":"successors","doc":"Gets the successors of a vertex identified by key.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1, 2, 3, 4\ndag.add_edge({1, 2}, {2, 3}, {2, 4})\ndag.successors(2) # => [3,4]\n```","summary":"<p>Gets the successors of a vertex identified by key.</p>","abstract":false,"args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"args_string":"(vertex : V)","args_html":"(vertex : V)","location":{"filename":"src/dag.cr","line_number":162,"url":null},"def":{"name":"successors","args":[{"name":"vertex","external_name":"vertex","restriction":"V"}],"visibility":"Public","body":"@vertices[vertex].successors"}},{"html_id":"valid?-instance-method","name":"valid?","doc":"Validate a graph, whether it is acyclic.\n\nExample:\n```\ndag = Dag::Graph(Int32).new\ndag.add 1, 2, 3, 4\ndag.add_edge({1, 2}, {2, 3}, {3, 4})\ndag.valid? # => true\ndag.add_edge(4, 2)\ndag.valid? # => false\n```","summary":"<p>Validate a graph, whether it is acyclic.</p>","abstract":false,"location":{"filename":"src/dag.cr","line_number":263,"url":null},"def":{"name":"valid?","visibility":"Public","body":"sorted, _unsorted = topological_sort\nsorted.size == @vertices.size\n"}}]},{"html_id":"dag/Dag/VertexExistsError","path":"Dag/VertexExistsError.html","kind":"class","full_name":"Dag::VertexExistsError","name":"VertexExistsError","abstract":false,"superclass":{"html_id":"dag/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"dag/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"dag/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"dag/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/dag.cr","line_number":335,"url":null}],"repository_name":"dag","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"dag/Dag","kind":"module","full_name":"Dag","name":"Dag"},"doc":"Raised when someone is adding a vertex to the graph but the vertex is almost presented.","summary":"<p>Raised when someone is adding a vertex to the graph but the vertex is almost presented.</p>","constructors":[{"html_id":"new(vertex)-class-method","name":"new","abstract":false,"args":[{"name":"vertex","external_name":"vertex","restriction":""}],"args_string":"(vertex)","args_html":"(vertex)","location":{"filename":"src/dag.cr","line_number":336,"url":null},"def":{"name":"new","args":[{"name":"vertex","external_name":"vertex","restriction":""}],"visibility":"Public","body":"_ = allocate\n_.initialize(vertex)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}]},{"html_id":"dag/Dag/VertexNotExistsError","path":"Dag/VertexNotExistsError.html","kind":"class","full_name":"Dag::VertexNotExistsError","name":"VertexNotExistsError","abstract":false,"superclass":{"html_id":"dag/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"dag/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"dag/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"dag/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/dag.cr","line_number":342,"url":null}],"repository_name":"dag","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"dag/Dag","kind":"module","full_name":"Dag","name":"Dag"},"doc":"Raised when someone is deleting a vertex which is not presented in graph.","summary":"<p>Raised when someone is deleting a vertex which is not presented in graph.</p>","constructors":[{"html_id":"new(vertex)-class-method","name":"new","abstract":false,"args":[{"name":"vertex","external_name":"vertex","restriction":""}],"args_string":"(vertex)","args_html":"(vertex)","location":{"filename":"src/dag.cr","line_number":343,"url":null},"def":{"name":"new","args":[{"name":"vertex","external_name":"vertex","restriction":""}],"visibility":"Public","body":"_ = allocate\n_.initialize(vertex)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}]}]}]}})