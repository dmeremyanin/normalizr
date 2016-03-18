class Book < ActiveRecord::Base
  normalize :author
  normalize :us_price, :cnd_price, with: :currency
  normalize_attributes :summary, with: [:strip, { truncate: { length: 12 }}, :blank]
  normalize_attributes :title do |value|
    String === value ? value.titleize.strip : value
  end

  serialize :tags, Array
  normalize :tags
end
