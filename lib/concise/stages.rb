require 'pp'
module Concise
  class Stage
    # This stage takes a tree of Concise::AST nodes and
    # simply calls the bytecode method on them.
    class Generator < RBX::Compiler::Stage
      next_stage RBX::Compiler::Encoder
      attr_accessor :variable_scope, :root

      def initialize(compiler, last)
        super
        @compiler = compiler
        @variable_scope = nil
        compiler.generator = self
      end

      def run
        @output = RBX::Generator.new

        @output.set_line Integer(1)

        # ENVIRONMENT INITIALIZATION
        # --------------------------

        # Initialize the heap as a one-cell array containing zero,
        # and the pointer as a zero integer.
        @output.meta_push_0
        @output.set_local 1
        @output.cast_array
        @output.set_local 0

        @input.each do |i|
          i.bytecode @output
        end

        bottom = @output.new_label

        @output.push_const :ENV
        @output.push_literal "DEBUG"
        @output.send :[], 1, false

        @output.gif bottom

        # Print the heap and the pointer if ENV['DEBUG']
        @output.push_literal "Heap: "

        @output.push_local 0
        @output.send :inspect, 0

        @output.push_literal "\nPointer: "
        @output.push_local 1
        @output.push_literal "\n"
        @output.send :print, 5, true
        # end Print

        bottom.set!

        @output.use_detected
        # Return the heap
        @output.push_local 0
        @output.ret
        @output.close

        run_next
      end
    end

    # AST trasnformation for evaling source string.
    #
    # This stage removes the ModuleNode from root of AST tree if
    # the code being compiled is going to be used for eval. We remove
    # the module, because in eval we must not return the module object
    # Also if the last statement is a DiscardNode, we replace it with
    # its inner expression, in order to return a value.
    #
    # If the source is not being compiled for eval, then output is
    # the same AST given as input.
    class EvalExpr < RBX::Compiler::Stage
      next_stage Generator

      def initialize(compiler, last)
        @compiler = compiler
        super
      end

      def run
        @output = @input
        run_next
      end
    end

    # This stage takes a ruby array as produced by the lexer
    # and produces a tree of Concise::AST nodes.
    class CnAST < RBX::Compiler::Stage
      next_stage EvalExpr

      def initialize(compiler, last)
        @compiler = compiler
        super
      end

      def run
        @output = Concise::Transformer.new.apply @input
        pp(@output) if @compiler.parser.print.ast?
        run_next
      end
    end

    # This stage takes python code and produces a ruby array
    # containing representation of the python source.
    # We are currently using python's own parser, so we just
    # read the sexp as its printed by bin/astpretty.py
    class CnCode < RBX::Compiler::Stage
      stage :concise_code
      next_stage CnAST
      attr_reader :filename, :line
      attr_accessor :print

      def initialize(compiler, last)
        super
        @print = Compiler::Print.new
        compiler.parser = self
      end

      def input(code, filename = "eval", line = 1)
        @code = code
        @filename = filename
        @line = line
      end

      def run
        @output = Concise::Parser.new.parse(@code)
        pp(@output) if @print.sexp?
        run_next
      end
    end

    # This stage takes a concise filename and produces a ruby array
    # containing representation of the concise source.
    class CnFile < RBX::Compiler::Stage
      stage :concise_file
      next_stage CnAST
      attr_reader :filename, :line
      attr_accessor :print

      def initialize(compiler, last)
        super
        @print = Compiler::Print.new
        compiler.parser = self
      end

      def input(filename, line = 1)
        @filename = filename
        @line = line
      end

      def run
        code = File.read(@filename)
        @output = Concise::Parser.new.parse(code)
        pp(@output) if @print.sexp?
        run_next
      end
    end
  end
end
