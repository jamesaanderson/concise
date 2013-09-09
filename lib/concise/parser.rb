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

    root :integer
  end
end
