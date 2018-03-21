module Normalizr
  class OptionsParser
    attr_reader :attributes, :options, :block

    def initialize(args, block)
      @options = Hash === args.last ? args.pop : {}
      @attributes = args
      @block = block
    end

    def before
      options_at(:with, :before) { block }
    end

    def after
      options_at(:after)
    end

    def positive_condition
      options_at(:if)
    end

    def negative_condition
      options_at(:unless)
    end

    private

    def options_at(*keys)
      block = yield if block_given?
      [ *options.values_at(*keys), block ].flatten.compact
    end
  end
end
