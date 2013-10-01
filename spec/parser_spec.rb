require 'spec_helper'
require 'parslet/rig/rspec'

describe Concise::Parser do
  let(:parser) { Concise::Parser.new }

  context 'integer' do
    it 'reads an integer' do
      expect(parser.integer).to parse('42')
    end
  end
end
