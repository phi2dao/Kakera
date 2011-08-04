require 'kakera/parser'
require 'kakera/node'

module Kakera
  class CharacterClassParser < Parser
    attr_reader :regexp
    
    def initialize string
      @string  = string
      @regexp = /[#{@string}]/
    end
    
    def to_s
      "[#{@string}]"
    end
    
    def dump
      super % (':' + @string)
    end
    
    def inspect indent = 0
      super % (': ' + to_s)
    end
    
    def eql? other
      super and other.regexp == @regexp
    end
    
    alias :== :eql?
    
    private
    def parse! stream, offset, options
      result = @regexp.match stream.getc
      if result
        SyntaxNode.new result.to_s, stream, offset, true # TODO: Subclasses and Mixins
      else
        ErrorNode.new "Failed to match [#{@string}]", stream, offset, true unless result
      end
    end
  end
end