# DAG - Directed Acyclic Graph  API

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?style=flat-square)](https://crystal-lang.org/)
[![Crystal CI](https://github.com/runcobo/runcobo/actions/workflows/crystal.yml/badge.svg)](https://github.com/dseres/dag/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/dseres/dag.svg)](https://github.com/dseres/dag/releases)
[![api docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://dseres.github.io/dag/)

A [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) (DAG) API written in the [crystal](https://crystal-lang.org/) programming languge.
This DAG implementation can be used for creating schedulers. E.g.: running multiple tasks which has predefined dependencies.


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     dag:
       github: dseres/dag
   ```

2. Run `shards install`

## Usage

Create a new Graph object. You can add and delete vertices and edges easily. If you enumarate the vertices with the #each method, the enumeration will be topologically sorted. The graph structure uses adjacency lists in the backend (implemented with Hash(K,V)), and you can store any hashable objects in it. 

```crystal
require "dag"
dag = Dag::Graph(Int32).new 
(1...10).each { |i| dag.add i}
dag.add_edge({1, 3} , {5, 9} , {8, 7} , {8, 6} , {6, 4} , {4, 3} , {4, 7})
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

- [dseres](https://github.com/dseres) - creator and maintainer
