require 'spec_helper'

describe Normalizr::Configuration do
  let(:configuration) { described_class.new }
  subject { configuration }

  describe '#default' do
    before { configuration.default(:blank) }
    its(:default_normalizers) { should == [:blank] }
  end

  describe '#normalizer_names' do
    before { allow(configuration).to receive(:normalizers) {{ blank: proc {}}}}
    its(:normalizer_names) { should == [:blank] }
  end

  describe '#add' do
    before { configuration.add(:blank) {}}
    its(:normalizer_names) { should include(:blank) }
  end
end
