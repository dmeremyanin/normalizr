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

      it 'raises the exception with normalizer in message' do
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

  describe '#process' do
    subject { described_class.process(obj, name, {}) }

    context 'string' do
      let(:obj) { ' test ' }

      context 'blank normalizer' do
        let(:name) { :strip }

        it 'strips the value' do
          should == 'test'
        end
      end
    end

    context 'array ' do
      let(:obj) { [nil, ' '] }

      context 'strip normalizer' do
        let(:name) { :strip }

        it 'strips all elements' do
          expect(subject).to eq([nil, ''])
        end
      end

      context 'custom normalizer' do
        let(:name) { proc { |value| value.prepend('N:') if String === value }}

        it 'processes all elements with the custom normalizer' do
          expect(subject).to eq([nil, 'N: '])
        end
      end

      context 'blank normalizer' do
        let(:name) { :blank }

        it 'returns empty array' do
          expect(subject).to eq([])
        end
      end
    end
  end

  describe '#normalize' do
    before  { configuration.default_normalizers = [:strip, :blank] }
    subject { described_class.normalize(value, *normalizers) }


    context 'normalizers are empty' do
      let(:normalizers) { [] }

      context 'string' do
        let(:value) { ' text ' }

        it 'uses the default normalizers' do
          expect(subject).to eq('text')
        end
      end

      context 'array' do
        let(:value) { [nil, ' test '] }

        it 'uses the default normalizers' do
          expect(subject).to eq(['test'])
        end
      end
    end

    context 'normalizers are not empty' do
      let(:normalizers) { [:strip, { truncate: { length: 8, omission: '...' }}, proc { |v| v.first(6) }] }

      context 'string' do
        let(:value) { ' Lorem ipsum dolor sit amet' }

        it 'strips, truncates and then slices the value' do
          expect(subject).to eq('Lorem.')
        end
      end

      context 'array' do
        let(:value) { [' Lorem ipsum dolor sit amet', '    One more sentence'] }

        it 'strips, truncates and then slices the value' do
          expect(subject).to eq(['Lorem.', 'One m.'])
        end
      end
    end

    context 'normalizers are default and custom' do
      let(:normalizers) { [:default, { truncate: { length: 8, omission: '...' }}, proc { |v| v.first(6) }] }
      let(:value) { ' Lorem ipsum dolor sit amet' }

      it 'uses the default normalizers, then truncates and slices the value' do
        expect(subject).to eq('Lorem.')
      end
    end
  end
end
