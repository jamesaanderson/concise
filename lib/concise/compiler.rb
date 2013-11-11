module Concise
  class Compiler
    attr_reader :filename, :classname, :outname

    def initialize(filename)
      @filename  = filename
      @classname = File.basename(@filename, '.cn').capitalize
      @outname   = filename + 'c'
    end

    def compile
      tree = parse_source
      klass = make_class(classname)

      method = klass.dynamic_method(:main) do |g|
        tree.each do |e|
          e.bytecode(g)
        end

        g.pop
        g.push_true
        g.ret
      end

      Rubinius::ToolSet::Runtime::CompiledFile.dump(method, outname, Rubinius::Signature, 18)
    end

    def eval
      compile if recompile?

      loader = Rubinius::CodeLoader.new(outname)
      method = loader.load_compiled_file(outname, Rubinius::Signature, 18)
      Rubinius.run_script(method)
    end

    private

    def parse_source
      source = File.expand_path(filename)
      program = IO.read(source)

      parser = Parser.new
      transformer = Transformer.new
      syntax = parser.parse(program)
      tree = transformer.apply(syntax)

      tree.is_a?(Array) ? tree : [tree]
    end

    def make_class(name)
      Object.const_set(name.to_sym, Class.new)
    end

    def recompile?
      !File.exists?(outname) || File.stat(outname).mtime < File.stat(filename).mtime
    end
  end
end
