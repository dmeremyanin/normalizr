require 'spec_helper'

describe Author do
  context 'Testing the built in normalizers' do
    # default normalization [ :strip, :blank ]
    it { should normalize(:name) }
    it { should normalize(:name).from(' this ').to('this') }
    it { should normalize(:name).from('   ').to(nil) }

    # :strip normalizer
    it { should normalize(:first_name).from('  this  ').to('this') }
    it { should normalize(:first_name).from('    ').to('') }

    # :squish normalizer
    it { should normalize(:nickname).from(' this    nickname  ').to('this nickname') }

    # :blank normalizer
    it { should normalize(:last_name).from('').to(nil) }
    it { should normalize(:last_name).from('  ').to(nil) }
    it { should normalize(:last_name).from(' this ').to(' this ') }

    # :whitespace normalizer
    it { should normalize(:biography).from("  this    line\nbreak ").to("this line\nbreak") }
    it { should normalize(:biography).from("\tthis\tline\nbreak ").to("this line\nbreak") }
    it { should normalize(:biography).from("  \tthis  \tline  \nbreak \t  \nthis").to("this line\nbreak\nthis") }
    it { should normalize(:biography).from('    ').to('') }

    # :control_chars normalizer
    it { should normalize(:bibliography).from("No \bcontrol\u0003 chars").to("No control chars") }
    it { should normalize(:bibliography).from("Except for\tspaces.\r\nAll kinds").to("Except for\tspaces.\r\nAll kinds") }

    # :parameterize normalizer
    it { should normalize(:slug).from("Obi One Kenobi").to("obi-one-kenobi") }
    it { should normalize(:slug).from("  ").to("") }
  end

  context 'on default attribute with the default normalizer changed' do
    it { should normalize(:phone_number).from('no-numbers-here').to(nil) }
    it { should normalize(:phone_number).from('1.877.987.9875').to('18779879875') }
    it { should normalize(:phone_number).from('+ 1 (877) 987-9875').to('18779879875') }
  end
end
