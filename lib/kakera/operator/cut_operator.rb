require 'kakera/operator'

module Kakera
  class CutOperator < Operator
    def to_s
      'CUT'
    end
    
    private
    def parse! stream, offset, options
      target = ascend {|n| n.runtime.key? :cut }
      target.runtime[:cut] = true if target
    end
  end
end