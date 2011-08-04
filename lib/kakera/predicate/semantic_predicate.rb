require 'kakera/parser'
require 'kakera/node'

module Kakera
  class SemanticPredicate < Parser
    attr_reader :block
    
    def initialize &block
      @block = block
    end
    
    def to_s
      '{...}'
    end
    
    def dump
      super % (':' + @block.hash)
    end
    
    def inspect indent = 0
      super % ''
    end
    
    def eql? other
      super and other.block == @block
    end
    
    alias :== :eql?
    
    private
    def parse! stream, offset, options
      target = ascend {|n| n.runtime.key? :nodes }
      if target
        array = target.runtime[:nodes]
      else
        array = []
      end
      result = @block.call array
      if result
        true
      else
        ErrorNode.new 'Internal block failure', stream, offset, true # TODO: Error Message
      end
    end
  end
end