module Concise
  class Parser < Parslet::Parser
    alias_method :`, :str

    rule(:space) do
      match[" \t\r\n"].repeat(1) |
      `#` >> match["^\r\n"].repeat
    end

    rule(:space?) do
      space.repeat
    end

    rule(:integer) do
      match('[-+]?[0-9]').repeat(1).as(:integer)
    end

    rule(:string) do
      `"` >>
      (
        `\\` >> any |
        `"`.absent? >> any
      ).repeat.as(:string) >>
      `"`
    end

    rule(:name) do
      match['A-Za-z_'].repeat(1)
    end

    rule(:args) do
      (expression.as(:arg) >> (comma >> expression.as(:arg)).repeat).as(:args)
    end

    rule(:comma) do
      space? >> `,` >> space?
    end

    rule(:funcall) do
      name.as(:funcall) >> space >> args
    end

    rule(:boolean) do
      (`true` | `false`).as(:boolean)
    end

    rule(:null) do
      `null`.as(:null)
    end

    rule(:expression) do
      funcall | integer | string | boolean | null
    end

    rule(:expressions) do
      (expression >> space?).repeat(1)
    end

    root :expressions
  end
end
