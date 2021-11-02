# In this example a custom class will be created to represent a vertex, and a function will be created to print the graph as a dot file.

require "../src/dag"

class DotNode
  property name : String
  property shape : String
  property color : String

  def initialize(@name, @shape = "box", @color = "black")
  end

  def hash
    name.hash
  end
end

def print_as_dot(dag : Dag::Graph(DotNode))
  puts "digraph {\n"
  dag.each do |dot_node|
    puts "\t#{dot_node.name} [ shape = #{dot_node.shape}, color = #{dot_node.color}]\n"
  end
  dag.each do |dot_node|
    dag.successors(dot_node).each do |succ|
      puts "\t#{dot_node.name} -> #{succ.name}\n"
    end
  end
  puts "}\n"
end

start_node = DotNode.new("start")
one = DotNode.new("one", "box", "cyan")
two = DotNode.new("two", "ellipse", "floralwhite")
three = DotNode.new("three")
four = DotNode.new("four", "diamond")
five = DotNode.new("five")
six = DotNode.new("six")

dag = Dag::Graph(DotNode).new
dag.add start_node, four
dag.add_edge start_node, one
dag.add_edge start_node, two
dag.add_edge two, three
dag.add_edge two, five
dag.add_edge five, six
dag.add_edge five, three

print_as_dot dag
