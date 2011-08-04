require 'kakera/helpers'
require 'kakera/parser'
require 'kakera/node'

module Kakera
  class NotPredicate < Parser
    attr_reader :element
    
    def initialize element
      @element = element
    end
    
    def to_s
      '!' + @element.to_s
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
        ErrorNode.new "Expected failure of #{@element}", stream, offset, true # TODO: Error Message
      else
        true
      end
    end
  end
end