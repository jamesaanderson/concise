module Concise
  class Integer < Struct.new(:value)
    def bytecode(g)
      g.push value
    end
  end
end
