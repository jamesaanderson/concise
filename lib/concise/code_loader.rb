module Concise
  class CodeLoader < Rubinius::CodeLoader

    def self.execute_code(code, print = Compiler::Print.new)
      cm = Compiler.compile_for_eval(code, binding.variables,
                                     "(eval)", 1, print)
      cm.scope = binding.constant_scope.dup
      cm.name = :__eval__

      script = Rubinius::CompiledMethod::Script.new(cm, "(eval)", true)
      script.eval_source = code

      cm.scope.script = script

      be = Rubinius::BlockEnvironment.new
      be.under_context(binding.variables, cm)
      be.call
    end

    # Takes a .cn file name, compiles it if needed and executes it.
    def self.execute_file(name, compile_to = nil, print = Compiler::Print.new)
      cm = Compiler.compile_if_needed(name, compile_to, print)
      ss = ::Rubinius::StaticScope.new Object
      code = Object.new
      ::Rubinius.attach_method(:__run__, cm, ss, code)
      code.__run__
    end
  end
end
