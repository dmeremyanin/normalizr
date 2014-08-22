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

  def configure
    configuration.instance_eval &Proc.new
  end

  def find(name)
    unless name.respond_to?(:call)
      configuration.normalizers.fetch(name) { raise MissingNormalizer.new(name) }
    else
      name
    end
  end

  def do(value, *normalizers)
    normalizers = configuration.default_normalizers if normalizers.empty?
    normalizers.each do |name|
      name, options = name.first if Hash === name
      value = find(name).call(value, options)
    end
    value
  end
end

require 'normalizr/normalizers'
ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, Normalizr::Concern)
end
