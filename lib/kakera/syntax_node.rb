module Kakera
  class SyntaxNode
    attr_reader :stream, :offset
    
    def initialize text, stream, offset, __terminal = false
      @text, @stream, @offset, @__terminal = text, stream, offset, __terminal
    end
    
    def terminal?
      @__terminal
    end
    
    def nonterminal?
      !@__terminal
    end
    
    def text
      @text.dup
    end
    
    def length
      @text.length
    end
    
    alias :size :length
    
    def interval
      @offset..(@offset + length)
    end
    
    alias :to_s :text
    
    def inspect indent = 0
      string = '  ' * indent
      string << %({#{self.class}: @#{@offset} "#{@text}"}\n)
      @elements.each {|n| string << n.inspect(indent + 1) } if @elements
      string
    end
  end
end