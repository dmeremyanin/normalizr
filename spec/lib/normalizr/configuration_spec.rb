require 'spec_helper'

describe Normalizr::Configuration do
  let(:configuration) { described_class.new }
  subject { configuration }

  describe '#default' do
    it 'accpets default normalizers' do
      subject.default(:blank)
      expect(subject.default_normalizers).to eq([:blank])
    end
  end

  describe '#normalizer_names' do
    it 'returns normalized names' do
      allow(subject).to receive(:normalizers) {{ blank: proc {}}}
      expect(subject.normalizer_names).to eq([:blank])
    end
  end

  describe '#add' do
    it 'requires block' do
      expect { subject.add(:blank) }.to raise_error(ArgumentError)
    end

    it 'accepts block' do
      subject.add(:blank) {}
      expect(subject.normalizer_names).to include(:blank)
    end
  end
end
