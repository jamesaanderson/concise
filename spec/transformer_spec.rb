require 'spec_helper'

describe Concise::Transformer do
  let(:transformer) { Concise::Transformer.new }

  context 'integer' do
    it 'transforms an integer' do
      input = {:integer => 42}

      expect(transformer.apply(input)).to be_kind_of(Concise::Integer)
    end
  end

  context 'string' do
    it 'transforms a string' do
      input = {:string => "Hello, World!"}

      expect(transformer.apply(input)).to be_kind_of(Concise::String)
    end
  end

  context 'funcall' do
    it 'transforms a funcall' do
      input = {:funcall=>"display", :args=>{:arg=>{:string=>"Hello, World!"}}}

      expect(transformer.apply(input)).to be_kind_of(Concise::Funcall)
    end
  end
end
