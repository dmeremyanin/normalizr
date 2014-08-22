## Normalizr

[![Travic CI](http://img.shields.io/travis/dimko/normalizr.svg)](https://travis-ci.org/dimko/normalizr) [![Code Climate](http://img.shields.io/codeclimate/github/dimko/normalizr.svg)](https://codeclimate.com/github/dimko/normalizr) [![Coverage](http://img.shields.io/codeclimate/coverage/github/dimko/normalizr.svg)](https://codeclimate.com/github/dimko/normalizr)

The [attribute_normalizer](https://github.com/mdeering/attribute_normalizer) replacement.

### Synopsis

Attribute normalizer doesn't normalize overloaded writer methods correctly. Example:

```ruby
class Currency
  include Normalizr::Concern

  attr_accessor :value
  normalize_attribute :value

  def value=(*)
    # ...
    super
  end
end
```

`value` will never be normalized as expected. Normalizr resolves this problem and doesn't generate any extra instance methods.

Magic based on ruby's `prepend` feature, so it requires 2.0 or higher version.

### Installation

Add this line to your application's Gemfile:

    gem 'normalizr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install normalizr

### Usage

Specify default normalizers:

```ruby
Normalizr.configure do
  default :strip, :blank
end
```

Add a custom normalizer:

```ruby
Normalizr.configure do
  add :titleize do |value|
    String === value ? value.titleize : value
  end

  add :truncate do |value, options|
    if String === value
      options.reverse_merge!(length: 30, omission: '...')
      l = options[:length] - options[:omission].mb_chars.length
      chars = value.mb_chars
      (chars.length > options[:length] ? chars[0...l] + options[:omission] : value).to_s
    else
      value
    end
  end

  add :indent do |value, amount = 2|
    value.indent!(amount) if String === value
    value
  end
end
```

Add attributes normalization:

```ruby
class User < ActiveRecord::Base
  normalize :first_name, :last_name, :about # with default normalizers
  normalize :email, with: :downcase

  # supports `normalize_attribute` and `normalize_attributes` as well
  normalize_attribute :skype
end

class Currency
  include Normalizr::Concern
  normalize :value
end
```

Normalize value outside class:

```ruby
Normalizr.normalize(value)
Normalizr.normalize(value, :strip, :blank)
Normalizr.normalize(value, :strip, truncate: { length: 20 })
```

### Built-in normalizers

- blank
- boolean
- capitalize
- control_chars
- downcase
- phone
- squish
- strip
- upcase
- whitespace

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Thanks

Special thanks to [Michael Deering](https://github.com/mdeering) for original idea.
