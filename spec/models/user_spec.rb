require 'spec_helper'

describe User do
  context 'on default attribute with the default normalizer changed' do
    it { should normalize_attribute(:firstname).from(' here ').to('here') }
  end
end
