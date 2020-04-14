require 'normalizr/concern'
require 'normalizr/configuration'
require 'normalizr/exceptions'
require 'normalizr/options_parser'
require 'normalizr/version'

module Normalizr
  extend self

  module RSpec
    autoload :Matcher, 'normalizr/rspec/matcher'
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configure(&block)
    unless block_given?
      raise ArgumentError, '.configure must be called with a block'
    end

    configuration.instance_eval(&block)
  end

  def find(name)
    unless name.respond_to?(:call)
      configuration.normalizers.fetch(name) { raise MissingNormalizer.new(name) }
    else
      name
    end
  end

  def process(obj, name, options)
    if Array === obj
      obj.map { |item| process(item, name, options) }.tap do |ary|
        ary.compact! if name == :blank
      end
    else
      find(name).call(obj, options)
    end
  end

  def normalize(obj, *normalizers)
    normalizers_with_default(normalizers).reduce(obj) do |memo, name|
      name, options = name.first if Hash === name

      process(memo, name, options)
    end
  end

  private

  def normalizers_with_default(normalizers)
    default_index = normalizers.index(:default)

    normalizers[default_index.to_i] = configuration.default_normalizers if normalizers.empty? || default_index
    normalizers.flatten!
    normalizers
  end
end

require 'normalizr/normalizers'
require 'normalizr/integrations/active_record' if defined?(ActiveRecord)
require 'normalizr/integrations/mongoid' if defined?(Mongoid)
require 'normalizr/integrations/rspec' if defined?(RSpec)
