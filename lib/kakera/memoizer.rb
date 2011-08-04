module Kakera
  class Memoizer
    def initialize
      @table = {}
    end
    
    def memoize parser, offset, &block
      dump = [parser.dump, offset]
      if @table.key? dump
        @table[dump]
      else
        node = block.call
        unless node.is_a?(Node) and node.terminal?
          @table[dump] = node
        end
        node
      end
    end
  end
end