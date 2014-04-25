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
      case bool
      when 'true'
        AST::Boolean::True.new
      when 'false'
        AST::Boolean::False.new
      end
    end

    rule(null: simple(:null)) do
      AST::Null.new
    end
  end
end
