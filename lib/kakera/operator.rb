class Kakera::Operator; end

require 'kakera/operator/cut_operator'

module Kakera
  class Operator
    attr_accessor :parent
    
    def dump offset
      %((#{self.class}))
    end
    
    def inspect indent = 0
      '  ' * indent + %(<-- #{self.class} -->\n)
    end
    
    def ascend &block
      return nil unless @parent
      if block.call @parent
        @parent
      else
        @parent.ascend &block
      end
    end
    
    def parse stream, options = {}
      stream = stream.to_stream
      parse! stream, stream.offset, options
      true
    end
    
    alias :match :parse
    
    def eql? other
      other.is_a? self.class
    end
    
    alias :== :eql?
  end
end