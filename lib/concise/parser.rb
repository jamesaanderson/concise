module Concise
  class Parser < Parslet::Parser
    rule(:space) do
      match('\s').repeat(1)
    end

    rule(:space?) do
      space.maybe
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
      name.as(:funcall) >> space >> args
    end

    rule(:expression) do
      funcall | integer | string
    end

    root :expression
  end
end
