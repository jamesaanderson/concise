module Concise::AST
  class Integer < Struct.new(:value)
    def bytecode(g)
      g.push_int value
    end
  end
end
