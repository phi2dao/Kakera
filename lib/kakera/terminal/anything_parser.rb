require 'kakera/parser'
require 'kakera/node'

module Kakera
  class AnythingParser < Parser
    def to_s
      '.'
    end
    
    def dump
      super % ''
    end
    
    def inspect indent = 0
      super % ''
    end
    
    private
    def parse! stream, offset, options
      if stream.eof?
        ErrorNode.new 'EOF', stream, offset, options
      else
        SyntaxNode.new stream.getc, stream, offset, true # TODO: Subclasses and Mixins
        end
    end
  end
end