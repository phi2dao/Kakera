module Kakera
  class Stream
    attr_reader :offset, :lineno
    
    def initialize string
      @string = string.to_s
      @offset = 0
      @lineno = 0
    end
    
    def eof?
      @offset >= @string.size
    end
    
    def length
      @string.length
    end
    
    alias :size :length
    
    def to_s
      @string.dup
    end
    
    def to_stream
      self
    end
    
    def getc
      char = @string[@offset]
      @lineno += 1 if char == "\n"
      @offset += 1 unless char.nil?
      char
    end
    
    def write other
      other = other.to_s
      @string.insert @offset, other
      @offset += other.length
      scan_lines
    end
    
    alias :<< :write
    
    def seek offset
      if @offset > offset
        @offset = offset
        scan_lines
      else
        until @offset == offset
          getc
        end
        @offset
      end
    end
    
    def rewind
      @offset = 0
      @lineno = 0
    end
    
    def lock &block
      offset, lineno = @offset, @lineno
      if [nil, true, false].include? block.call(@offset)
        @offset, @lineno = offset, lineno
      end
      result
    end
    
    private
    def scan_lines
      @lineno = 0
      0.upto @offset do |i|
        @lineno += 1
      end
    end
  end
end

class String
  def to_stream
    Stream.new self
  end
end

class File
  def to_stream
    string = ''
    self.each_char do |c|
      string << c
    end
    Stream.new string
  end
end