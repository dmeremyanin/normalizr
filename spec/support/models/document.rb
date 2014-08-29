class Document
  include Mongoid::Document

  field :name, type: String
  normalize_attribute :name
end
