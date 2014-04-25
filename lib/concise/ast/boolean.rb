module Concise::AST
  class Boolean
    class True
      def bytecode(g)
        g.push_true
      end
    end

    class False
      def bytecode(g)
        g.push_false
      end
    end
  end
end
