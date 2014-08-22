require 'spec_helper'

describe Normalizr do
  let(:configuration) { Normalizr.configuration }

  describe '#find' do
    subject { described_class.find(normalizer) }

    context 'existed normalizer' do
      let(:normalizer) { :blank }

      it 'returns normalizer' do
        expect(subject).to be_a(Proc)
      end
    end

    context 'not existed normalizer' do
      let(:normalizer) { :not_existed }

      it 'raise exception with normalizer in message' do
        expect { subject }.to raise_error(Normalizr::MissingNormalizer, /not_existed/)
      end
    end

    context 'proc' do
      let(:normalizer) { proc {} }

      it 'returns parameter' do
        expect(subject).to eq(normalizer)
      end
    end
  end

  describe '#do' do
    before  { configuration.default_normalizers = [:strip, :blank] }
    subject { described_class.do(value, *normalizers) }

    context 'normalizers is empty' do
      let(:normalizers) { [] }
      let(:value) { ' text ' }
      it { should == 'text' }
    end

    context 'normalizers is not empty' do
      let(:normalizers) { [truncate: { length: 8, omission: '...' }] }
      let(:value) { 'Lorem ipsum dolor sit amet' }
      it { should == 'Lorem...' }
    end

    context 'proc' do
      let(:normalizers) { [proc { |v| v.first(5) }] }
      let(:value) { 'Lorem ipsum dolor sit amet' }
      it { should == 'Lorem' }
    end
  end


  describe '#do' do
    before  { configuration.default_normalizers = [:strip, :blank] }
    subject { described_class.do(value, *normalizers) }

    context 'normalizers is empty' do
      let(:normalizers) { [] }
      let(:value) { ' text ' }

      it 'use default normalizers' do
        expect(subject).to eq('text')
      end
    end

    context 'normalizers is not empty' do
      let(:normalizers) { [:strip, { truncate: { length: 8, omission: '...' }}, proc { |v| v.first(6) }] }
      let(:value) { ' Lorem ipsum dolor sit amet' }

      it 'normalize value' do
        expect(subject).to eq('Lorem.')
      end
    end
  end
end
