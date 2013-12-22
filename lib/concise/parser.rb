module Concise
  class Parser < Parslet::Parser
    rule(:space) do
      match[" \t\r\n"].repeat(1) |
      str('#') >> match["^\r\n"].repeat
    end

    rule(:space?) do
      space.repeat
    end

    rule(:integer) do
      match('[-+]?[0-9]').repeat(1).as(:integer) >> space?
    end

    rule(:string) do
      str('"') >>
      (
        str('\\') >> any |
        str('"').absent? >> any
      ).repeat.as(:string) >>
      str('"') >> space?
    end

    rule(:name) do
      match['A-Za-z_'].repeat(1)
    end

    rule(:args) do
      (expression.as(:arg) >> (comma >> expression.as(:arg).repeat).maybe).as(:args)
    end

    rule(:comma) do
      str(',') >> space?
    end

    rule(:funcall) do
      name.as(:funcall) >> space >> args >> space?
    end

    rule(:boolean) do
      (str('true') | str('false')).as(:boolean) >> space?
    end

    rule(:expression) do
      space? >> (funcall | integer | string | boolean)
    end

    root :expression
  end
end
