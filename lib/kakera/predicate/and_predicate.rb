require 'kakera/helpers'
require 'kakera/parser'
require 'kakera/node'

module Kakera
  class AndPredicate < Parser
    attr_reader :element
    
    def initialize element
      @element = element
    end
    
    def to_s
      '&' + @element.to_s
    end
    
    def dump
      super % (':' + @element.dump)
    end
    
    def inspect indent = 0
      super % ''
    end
    
    def eql? other
      super and other.element == @element
    end
    
    alias :== :eql?
    
    private
    def parse! stream, offset, options
      @element.parent = self
      result = @element.parse stream, options
      if Kakera.success? result
        true
      else
        ErrorNode.new "Expected success of #{@element}", stream, offset, false, result # TODO: Error Message
      end
    end
  end
end