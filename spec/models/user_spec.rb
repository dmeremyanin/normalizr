require 'spec_helper'

describe User do
  context 'on default attribute with the default normalizer changed' do
    it { should normalize_attribute(:firstname).from(' here ').to('here') }
  end

  context 'last name has to be normalized' do
    before do
      allow(subject).to receive(:should_normalize_lastname?).and_return(true)
    end

    it { is_expected.to normalize_attribute(:lastname).from(' here ').to('here') }
  end

  context 'last name cannot be normalized' do
    before do
      allow(subject).to receive(:should_normalize_lastname?).and_return(false)
    end

    it { is_expected.not_to normalize_attribute(:lastname).from(' here ').to('here') }
  end

  context 'maidenname has to be normalized' do
    before do
      allow(subject).to receive(:should_normalize_maidenname_positive?).and_return(true)
      allow(subject).to receive(:should_normalize_maidenname_negative?).and_return(false)
    end

    it { is_expected.to normalize_attribute(:maidenname).from(' boba ').to('boba') }
  end

  context 'maidenname cannot to be normalized' do
    before do
      allow(subject).to receive(:should_normalize_maidenname_positive?).and_return(true)
      allow(subject).to receive(:should_normalize_maidenname_negative?).and_return(true)
    end

    it { is_expected.not_to normalize_attribute(:maidenname).from(' boba ').to('boba') }
  end

  context 'favouritebook has to be normalized with proc' do
    it { is_expected.to normalize_attribute(:favouritebook).from(' Евангелие от Матфея ').to('Евангелие от Матфея') }
  end
end
