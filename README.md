## Normalizr

[![Gem Version](https://badge.fury.io/rb/normalizr.svg)](https://badge.fury.io/rb/normalizr)
[![Build Status](https://travis-ci.org/dimko/normalizr.svg?branch=master)](https://travis-ci.org/dimko/normalizr)
[![Code Climate](https://codeclimate.com/github/dimko/normalizr/badges/gpa.svg)](https://codeclimate.com/github/dimko/normalizr)
[![Test Coverage](https://codeclimate.com/github/dimko/normalizr/badges/coverage.svg)](https://codeclimate.com/github/dimko/normalizr/coverage)

The [attribute_normalizer](https://github.com/mdeering/attribute_normalizer) replacement.

### Synopsis

Attribute normalizer doesn't normalize overloaded methods correctly. Example:

```ruby
class Phone
  include AttributeNormalizer

  attr_accessor :number
  normalize_attribute :number

  def number=(value)
    @number = value
  end
end
```

`number` will never be normalized as expected. Normalizr resolves this problem and doesn't pollute target object namespace.

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

Register custom normalizer:

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
    if String === value
      value.indent(amount)
    else
      value
    end
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

  # array normalization is supported too
  normalize :skills
end

user = User.new(first_name: '', last_name: '', skills: [nil, '', ' ruby'])
user.email = "ADDRESS@example.com"

user.first_name
#=> nil
user.last_name
#=> nil
user.email
#=> "address@example.com"
user.skills
#=> ["ruby"]
```

```ruby
class SMS
  include Normalizr::Concern

  attr_accessor :phone, :message

  normalize :phone, with: :phone
  normalize :message

  def initialize(phone, message)
    self.phone   = phone
    self.message = message
  end
end

sms = SMS.new("+1 (810) 555-0000", "It works \n")
sms.phone
#=> "18105550000"
sms.message
#=> "It works"
```

You can also use if/unless options (they accept a symbol (method name) or proc):

```ruby
class Book
  include Normalizr::Concerns

  attr_accessor :author, :description, :date

  normalize :author, if: :author_should_be_normalized?
  normalize :description, unless: :description_should_not_be_normalized?

  normalize :author, if: -> { date.today? }
end
```

Normalize values outside of class:

```ruby
Normalizr.normalize(value)
Normalizr.normalize(value, :strip, :blank)
Normalizr.normalize(value, :strip, truncate: { length: 20 })
```

### ORMs

Normalizr automatically loads into:

* ActiveRecord
* Mongoid

### RSpec matcher

```ruby
describe User do
  it { should normalize(:name) }
  it { should normalize(:phone).from('+1 (810) 555-0000').to('18105550000') }
  it { should normalize(:email).from('ADDRESS@example.com').to('address@example.com') }
end
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
