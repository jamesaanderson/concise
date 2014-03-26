module Concise::AST
  class Null
    def bytecode(g)
      g.push_nil
    end
  end
end
