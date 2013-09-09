module Concise
  class Transformer < Parslet::Transform
    rule(integer: simple(:int)) do
      Integer.new(int.to_i)
    end
  end
end
