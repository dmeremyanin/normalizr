require 'spec_helper'

describe Normalizr::Concern do
  subject { Class.new { include Normalizr::Concern }}

  it { should respond_to(:normalize) }
  it { should respond_to(:normalize_attributes) }
  it { should respond_to(:normalize_attribute) }
end
