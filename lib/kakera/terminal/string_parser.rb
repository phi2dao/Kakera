require 'kakera/parser'
require 'kakera/node'

module Kakera
  class StringParser < Parser
    attr_reader :string
    
    def initialize string
      @string = string
    end
    
    def to_s
      @string.inspect
    end
    
    def dump
      super % (':' + @string)
    end
    
    def inspect indent = 0
      super % (': ' + @string.inspect)
    end
    
    def eql? other
      super and other.string == @string
    end
    
    alias :== :eql?
    
    private
    def parse! stream, offset, options
      string = ''
      @string.each_char do |char|
        return ErrorNode.new "Failed to match \"#{char}\" in \"#{@string}\"", stream, offset, true if stream.eof?
        if char == stream.getc
          string << char
        else
          return ErrorNode.new "Failed to match \"#{char}\" in \"#{@string}\"", stream, offset, true
        end
      end
      SyntaxNode.new string, stream, offset, true # TODO: Subclassing and Mixins
    end
  end
end