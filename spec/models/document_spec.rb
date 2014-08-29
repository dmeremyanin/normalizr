require 'spec_helper'

describe Document do
  it { should normalize(:name) }
  it { should normalize(:name).from(' this ').to('this') }
  it { should normalize(:name).from('   ').to(nil) }
end
