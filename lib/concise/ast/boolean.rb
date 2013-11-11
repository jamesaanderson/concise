module Concise::AST
  class Boolean < Struct.new(:value)
    def bytecode(g)
      case value
      when 'true'
        g.push_true
      when 'false'
        g.push_false
      end
    end
  end
end
