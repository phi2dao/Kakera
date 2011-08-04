require 'kakera/helpers'
require 'kakera/parser'
require 'kakera/node'

module Kakera
  class RepetitionParser < Parser
    attr_reader :element, :min, :max
    
    def initialize element, min, max = 0
      @element, @min, @max = element, min, max
    end
    
    def to_s
      "<#{@element} (#{@min}..#{@max == 0 ? '' : @max})>"
    end
    
    def dump
      super % (':' + "#{@element.dump}:#{@min}:#{@max}")
    end
    
    def inspect indent = 0
      super % ": (#{@min}..#{@max == 0 ? '' : @max})"
    end
    
    def eql? other
      super and other.element == @element and other.min == @min and other.max == @max
    end
    
    alias :== :eql?
    
    private
    def open_runtime
      @runtime[:nodes] = []
      @runtime[:cut] = false
    end
    
    def parse! stream, offset, options
      @element.parent = self
      nodes = @runtime[:nodes]
      loop do
        break if nodes.length > @max if @max > 0
        result = @element.parse stream, options
        if @runtime[:cut]
          return ErrorNode.new '', stream, offset, false, result unless Kakera.success? result # TODO: Error Message
        else
          break unless Kakera.success? result
        end
        nodes << result if result.is_a? SyntaxNode
      end
      if nodes.length >= @min
        SyntaxNode.new nodes.join, stream, offset, false, *nodes # TODO: Subclassing and Mixins
      else
        ErrorNode.new "Expected at least #{@min} of #{@element}", stream, offset, true # TODO: Error Messaging
      end
    end
  end
end