class Kakera::Parser; end

require 'kakera/helpers'
require 'kakera/memoizer'
require 'kakera/terminal'
require 'kakera/nonterminal'
require 'kakera/predicate'
require 'kakera/node'

module Kakera
  class Parser
    DEFAULT_PARSE_OPTIONS = {
      :consume_all_input => true,
      }
    DEFAULT_MATCH_OPTIONS = {
      :consume_all_input => false,
      :memoizer => nil,
      }
    
    attr_accessor :parent, :runtime
    
    def dump
      "(#{self.class}%s)"
    end
    
    def inspect indent = 0
      string = '  ' * indent + "<#{self.class}%s>\n"
      @elements.each {|n| string << n.inspect(indent + 1) } if @elements
      string << @element.inspect(indent + 1) if @element
      string
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
      unless options[:lock]
        options.merge! DEFAULT_PARSE_OPTIONS
        options[:memoizer] = Memoizer.new unless options.key? :memoizer
        options[:lock] = true
      end
      
      unless @parent
        stream.seek options[:index] if options.key? :index
      end
      
      @runtime = {}
      open_runtime
      results = stream.lock do |orig|
        if options[:memoizer]
          options[:memoizer].memoize self, orig do
           parse! stream, orig, options
          end
        else
          parse! stream, orig, options
        end
      end
      close_runtime
      @runtime = nil
      
      unless @parent
        if options[:consume_all_input]
          return ErrorNode.new 'All input not consumed', stream, stream.offset, true if Kakera.success?(results) and !stream.eof?
        end
      end
      
      results
    end
      
    def match stream, options = {}
      unless options[:lock]
        options.merge! DEFAULT_MATCH_OPTIONS
        options[:lock] = true
      end
      result = SequenceParser.new(RepetitionParser.new(SequenceParser.new(NotPredicate.new(self), AnythingParser.new), 0), self).parse stream, options
      if result.is_a? SyntaxNode
        result.elements[1]
      else
        result.elements[0]
      end
    end
    
    def eql? other
      other.is_a? self.class
    end
    
    alias :== :eql?
    
    private
    def open_runtime; end
    
    def close_runtime; end
  end
end