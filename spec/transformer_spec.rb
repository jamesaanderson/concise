require 'spec_helper'

describe Concise::Transformer do
  let(:transformer) { Concise::Transformer.new }

  context 'integer' do
    it 'transforms an integer' do
      input = {:integer => 42}
      expected = Concise::Integer.new(42)

      expect(transformer.apply(input)).to eq(expected)
    end
  end

  context 'string' do
    it 'transforms a string' do
      input = {:string => "Hello, World"}
      expected = Concise::String.new("Hello, World")

      expect(transformer.apply(input)).to eq(expected)
    end
  end
end
