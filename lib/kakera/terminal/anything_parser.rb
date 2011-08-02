module Kakera
  class AnythingParser
    private
    def parse! stream, offset, options
      stream.eof? ? nil : SyntaxNode.new(stream.getc, stream, offset, true) # TODO: Error Messaging, Subclasses and Mixins
    end
  end
end