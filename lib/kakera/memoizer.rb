module Kakera
  class Memoizer
    def initialize
      @table = {}
    end
    
    def memoizer parser, offset &block
      return block.call if parser.is_a? Operator
      dump = parser.dump offset
      if @table.key? dump
        @table[dump]
      else
        node = block.call
        @table[dump] = node unless node.terminal?
      end
    end
  end
end