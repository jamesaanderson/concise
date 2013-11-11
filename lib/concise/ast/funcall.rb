module Concise::AST
  class Funcall
    attr_reader :name, :args

    def initialize(name, args)
      @name = name
      @args = args.is_a?(Array) ? args : [args]
    end

    def bytecode(g)
      g.push_self
      args.each { |a| a.bytecode(g) }
      g.allow_private

      case name
      when 'display'
        g.send :puts, args.length
      else
        g.send name.to_sym, args.length
      end
    end
  end
end
