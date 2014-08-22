module Normalizr
  class MissingNormalizer < StandardError
    def initialize(name)
      super "undefined normalizer #{name}"
    end
  end
end
