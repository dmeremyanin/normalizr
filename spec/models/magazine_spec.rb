require 'spec_helper'

describe Magazine do
  it { should normalize_attribute(:name).from(' Plain Old Ruby Objects ').to('Plain Old Ruby Objects') }
  it { should normalize_attribute(:us_price).from('$3.50').to('3.50') }
  it { should normalize_attribute(:cnd_price).from('$3,450.98').to('3450.98') }
  it { should normalize_attribute(:sold).from('true').to(true) }
  it { should normalize_attribute(:sold).from('0').to(false) }
  it { should normalize_attribute(:sold).from('').to(nil) }

  it { should normalize_attribute(:summary).from('    Here is my summary that is a little to long  ').
    to('Here is m...') }

  it { should normalize_attribute(:title).from('some really interesting title').
    to('Some Really Interesting Title') }

end
