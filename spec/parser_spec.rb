require 'spec_helper'
require 'parslet/rig/rspec'

describe Concise::Parser do
  let(:parser) { Concise::Parser.new }

  context 'integer' do
    it 'reads an integer' do
      expect(parser.integer).to parse('42')
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
    end
  end
end
