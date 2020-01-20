lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'normalizr/version'

Gem::Specification.new do |spec|
  spec.name          = 'normalizr'
  spec.version       = Normalizr::VERSION
  spec.authors       = ['Dimko']
  spec.email         = ['deemox@gmail.com']
  spec.description   = 'Writer methods parameters normalization'
  spec.summary       = 'Writer methods parameters normalization'
  spec.homepage      = 'https://github.com/dmeremyanin/normalizr'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec',        '~> 3.0'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'fuubar'
  spec.add_development_dependency 'mongoid',      '>= 3.0'
  spec.add_development_dependency 'activerecord', '>= 3.0'
  spec.add_development_dependency 'sqlite3'
end
