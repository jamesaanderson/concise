module Concise::AST
  class String < Struct.new(:value)
    def bytecode(g)
      g.push_literal value
      g.string_dup
    end
  end
end
