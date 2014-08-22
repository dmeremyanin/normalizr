require 'support/codeclimate'
require 'pry'
require 'rspec'
require 'rspec/its'
require 'active_record'
require 'normalizr'

ActiveRecord::Migration.suppress_messages do
  require 'support/connection'
  require 'support/schema'
end

require 'support/models/article'
require 'support/models/author'
require 'support/models/book'
require 'support/models/journal'
require 'support/models/magazine'
require 'support/models/person'
require 'support/models/publisher'
require 'support/models/user'

RSpec.configure do |config|
  config.include Normalizr::RSpec::Matcher
end

Normalizr.configure do |config|
  default :strip, :special_normalizer, :blank

  add :currency do |value|
    String === value ? value.gsub(/[^0-9\.]+/, '') : value
  end

  add :special_normalizer do |value|
    if String === value && /testing the default normalizer/ === value
      'testing the default normalizer'
    else
      value
    end
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
end
