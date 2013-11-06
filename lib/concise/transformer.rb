module Concise
  class Transformer < Parslet::Transform
    rule(arg: simple(:arg)) do
      arg
    end

    rule(funcall: simple(:funcall), args: simple(:args)) do
      Funcall.new(funcall, args)
    end

    rule(funcall: simple(:funcall), args: sequence(:args)) do
      Funcall.new(funcall, args)
    end

    rule(integer: simple(:int)) do
      Integer.new(int.to_i)
    end

    rule(string: simple(:str)) do
      String.new(str.to_s)
    end
  end
end
