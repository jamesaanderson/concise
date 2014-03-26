module Concise::AST
  class Null < Struct.new(:value)
    def bytecode(g)
      g.push_nil
    end
  end
end
