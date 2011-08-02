require 'kakera/memoizer'

module Kakera
  class Parser
    attr_accessor :parent
    
    def parse stream, options = {}
      stream.to_stream
      options[:memoizer] = Memoizer.new unless options.key? :memoizer
      # Handle defaults
      
      stream.lock do |orig|
        options[:memoizer].memoize self, orig do
          parse! stream, orig, options
        end
      end
    end
    
    def match stream, options = {}
      # Handle defaults
      parse stream, options
    end
    
    def eql? other
      self.class == other.class
    end
    
    alias :== :eql?
    
    private
    def ascend &block
      return nil unless @parent
      if block.call @parent
        @parent
      else
        @parent.ascend &block
      end
    end
  end
end