module Normalizr
  module Concern
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def normalize(*args, &block)
        options = Normalizr::OptionsParser.new(args, block)

        prepend Module.new {
          options.attributes.each do |method|
            define_method :"#{method}=" do |value|
              value = Normalizr.normalize(value, *options.pre)
              value = Normalizr.normalize(value, *options.post) if options.post.any?
              super(value)
            end
          end
        }
      end

      # attribute normalizer compatibility
      alias_method :normalize_attribute,  :normalize
      alias_method :normalize_attributes, :normalize
    end
  end
end
