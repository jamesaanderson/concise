module Concise 
  class Compiler
    attr_reader :filename, :classname, :outname

    def initialize(filename)
      @filename  = filename
      @classname = File.basename(@filename, '.cn').capitalize
      @outname   = File.basename(@filename, '.cn') + '.rbc'
    end

    def compile
      tree = parse_source
      klass = make_class(classname)

      method = klass.dynamic_method(:main) do |generator|
        tree.each do |e|
          e.bytecode(generator)
        end

        generator.ret
      end

      Rubinius::CompiledFile.dump(method, outname, Rubinius::Signature, 18)
    end

    def eval
      unless File.exists?(outname)
        compile
      end

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
  end
end
