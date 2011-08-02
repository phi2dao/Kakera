require 'kakera/parser'
require 'kakera/syntax_node'

module Kakera
  class CharacterClassParser < Parser
    attr_reader :regexp
    
    def initialize regexp
      @regexp = regexp
    end
    
    private
    def parse! stream, offset, options
      result = @regexp.match stream.getc
      return nil unless result # TODO: Error Messaging
      SyntaxNode.new result.to_s, stream, offset, true # TODO: Subclasses and Mixins
    end
  end
end