class Phone
  include Normalizr::Concern

  attr_accessor :number
  normalize_attribute :number

  def number=(value)
    @number = value
  end
end
