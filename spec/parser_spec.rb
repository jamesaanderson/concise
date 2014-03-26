require 'spec_helper'
require 'parslet/rig/rspec'

describe Concise::Parser do
  let(:parser) { Concise::Parser.new }

  context 'integer' do
    it 'reads an integer' do
      expect(parser.integer).to parse('42')
      expect(parser.integer).to parse('-42')
      expect(parser.integer).to_not parse('3.14')
    end
  end

  context 'string' do
    it 'reads a string' do
      expect(parser.string).to parse('"Hello, World!"')
    end
  end

  context 'funcall' do
    it 'reads a funcall' do
      expect(parser.funcall).to parse('display "Hello, World!"')
    end
  end

  context 'boolean' do
    it 'reads a boolean' do
      expect(parser.boolean).to parse('true')
      expect(parser.boolean).to parse('false')
      expect(parser.boolean).to_not parse('truefalse')
    end
  end

  context 'null' do
    it 'reads null' do
      expect(parser.null).to parse('null')
    end
  end
end
