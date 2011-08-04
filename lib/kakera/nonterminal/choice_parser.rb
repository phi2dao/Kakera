require 'kakera/helpers'
require 'kakera/parser'
require 'kakera/node'

module Kakera
  class ChoiceParser < Parser
    attr_reader :elements
    
    def initialize *elements
      @elements = elements
    end
    
    def to_s
      '<' + @elements.join(' / ') + '>'
    end
    
    def dump
      super % (':' + @elements.collect {|n| n.dump }.join(','))
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
      @runtime[:cut] = false
    end
    
    def parse! stream, offset, options
      nodes = []
      @elements.each do |n|
        n.parent = self
        node = n.parse stream, options
        if Kakera.success? node
          return node # TODO: Subclassing and Mixins
        else
          nodes << node
        end
        break if @runtime[:cut]
      end
      return ErrorNode.new "Failed to match alternatives #{to_s}", stream, offset, false, *nodes # TODO: Error Message
    end
  end
end