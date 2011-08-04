module Kakera
  class Node
    attr_reader :stream, :offset
    
    def initialize text, stream, offset, __terminal = true, *elements
      @text, @stream, @offset, @__terminal = text, stream, offset, __terminal
      @elements = elements
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
    
    alias :to_s :text
    
    def elements
      if @__terminal
        nil
      else
        @elements
      end
    end
    
    def inspect indent = 0
      string = '  ' * indent + "#{self.class}: @#{@offset} #{@text.inspect}\n"
      @elements.each {|n| string << n.inspect(indent + 1) }
      string
    end
  end
  
  class SyntaxNode < Node; end
  
  class ErrorNode < Node; end
end