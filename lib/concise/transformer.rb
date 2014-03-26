module Concise
  class Transformer < Parslet::Transform
    rule(arg: simple(:arg)) do
      arg
    end

    rule(funcall: simple(:funcall), args: simple(:args)) do
      AST::Funcall.new(funcall, args)
    end

    rule(funcall: simple(:funcall), args: sequence(:args)) do
      AST::Funcall.new(funcall, args)
    end

    rule(integer: simple(:int)) do
      AST::Integer.new(int.to_i)
    end

    rule(string: simple(:str)) do
      AST::String.new(str.to_s)
    end

    rule(boolean: simple(:bool)) do
      AST::Boolean.new(bool)
    end

    rule(null: simple(:null)) do
      AST::Null.new(null)
    end
  end
end
