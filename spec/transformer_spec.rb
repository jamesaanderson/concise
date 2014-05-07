require 'spec_helper'

describe Concise::Transformer do
  let(:transformer) { Concise::Transformer.new }

  context 'integer' do
    it 'transforms an integer' do
      input = {:integer => 42}

      expect(transformer.apply(input)).to be_kind_of(Concise::AST::Integer)
    end
  end

  context 'string' do
    it 'transforms a string' do
      input = {:string => "Hello, World!"}

      expect(transformer.apply(input)).to be_kind_of(Concise::AST::String)
    end
  end

  context 'funcall' do
    it 'transforms a funcall' do
      input = {:funcall=>"disp", :args=>{:arg=>{:string=>"Hello, World!"}}}

      expect(transformer.apply(input)).to be_kind_of(Concise::AST::Funcall)
    end
  end

  context 'boolean' do
    it 'transforms a boolean' do
      t = {:boolean => "true"}
      f = {:boolean => "false"}

      expect(transformer.apply(t)).to be_kind_of(Concise::AST::Boolean::True)
      expect(transformer.apply(f)).to be_kind_of(Concise::AST::Boolean::False)
    end
  end

  context 'null' do
    it 'transforms null' do
      input = {:null => "null"}

      expect(transformer.apply(input)).to be_kind_of(Concise::AST::Null)
    end
  end
end
