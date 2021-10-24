# dag

A Crystal module to handle [directed acyclic graphs](https://en.wikipedia.org/wiki/Directed_acyclic_graph) (DAG)

This DAG implementation can be used for creating schedulers. E.g.: running multiple tasks which has predefined dependencies.

[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://dseres.github.io/dag/)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     dag:
       github: your-github-user/dag
   ```

2. Run `shards install`

## Usage

Create a new Graph object. You can add and delete vertices and edges easily. If you enumarate the vertices with the #each method, the enumeration will be topologically sorted. 

```crystal
require "dag"
dag = Graph(Int32).new 
(1...10).each { |i| dag.add i}
dag.add_edge(1, 3)
dag.add_edge(5, 9)
dag.add_edge(8, 7)
dag.add_edge(8, 6)
dag.add_edge(6, 4)
dag.add_edge(4, 3)
dag.add_edge(4, 7)
dag.successors 4 # => [3,7]
dag.each { |v| p! v}
dag.to_a # => [1, 2, 5, 9, 8, 6, 4, 3, 7]
```

## Contributing

1. Fork it (<https://github.com/your-github-user/dag_cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [dseres](https://github.com/your-github-user) - creator and maintainer
