module Concise
  class Integer < Struct.new(:value)
    def bytecode(g)
      g.push value
    end
  end

  class String < Struct.new(:value)
    def bytecode(g)
      g.push_literal value
      g.string_dup
    end
  end
end
