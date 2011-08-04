require 'kakera/helpers'
require 'kakera/parser'
require 'kakera/node'

module Kakera
  class SequenceParser < Parser
    attr_reader :elements
    
    def initialize *elements
      @elements = elements
    end
    
    def to_s
      '<' + @elements.join(' ') + '>'
    end
    
    def dump 
      super % (':' + @elements.collect {|n| n.dump}.join(','))
    end
    
    def inspect indent = 0
      super % ''
    end
    
    def append other
      @elements << other
    end
    
    alias :<< :append
    
    def eql? other
      super and other.elements == @elements
    end
    
    alias :== :eql?
    
    private
    def open_runtime
      @runtime[:nodes] = []
    end
    
    def parse! stream, offset, options
      nodes = @runtime[:nodes]
      @elements.each do |n|
        n.parent = self
        result = n.parse stream, options
        return ErrorNode.new "Failed to match sequence #{to_s}", stream, offset, false, result unless Kakera.success? result
        nodes << result if result.is_a? SyntaxNode
      end
      SyntaxNode.new nodes.join, stream, offset, false, *nodes # TODO: Subclassing and Mixins
    end
  end
end