module Concise
  class Transformer < Parslet::Transform
    rule(integer: simple(:int)) do
      Integer.new(int.to_i)
    end

    rule(string: simple(:str)) do
      String.new(str.to_s)
    end
  end
end
