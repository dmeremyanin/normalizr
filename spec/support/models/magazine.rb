class Magazine
  include Normalizr::Concern

  attr_accessor :name,
                :cnd_price,
                :us_price,
                :summary,
                :title,
                :sold

  normalize :name
  normalize :us_price, :cnd_price, with: :currency
  normalize :summary, with: [:strip, { truncate: { length: 12 }}, :blank]
  normalize :sold, with: :boolean
  normalize :title do |value|
    String === value ? value.titleize.strip : value
  end
end
