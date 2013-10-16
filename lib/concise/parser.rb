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

    rule(:expression) do
      (integer | string).repeat
    end

    root :expression
  end
end
