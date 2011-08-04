require 'kakera/node'

module Kakera
  module_function
  def success? node
    [SyntaxNode, TrueClass].include? node.class
  end
end