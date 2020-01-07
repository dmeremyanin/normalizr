module Normalizr
  class Configuration
    attr_accessor :default_normalizers

    def normalizers
      @normalizers ||= {}
    end

    def normalizer_names
      normalizers.keys
    end

    def default(*normalizers)
      self.default_normalizers = normalizers
    end

    def add(name, &block)
      unless block_given?
        raise ArgumentError, '#add must be called with a block'
      end

      normalizers[name] = block
    end
  end
end
