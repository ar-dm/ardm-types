# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-types/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name             = "ardm-types"
  gem.version          = DataMapper::Types::VERSION

  gem.authors          = [ 'Martin Emde', 'Dan Kubb' ]
  gem.email            = [ 'me@martinemde.com', "dan.kubb@gmail.com" ]
  gem.summary          = "Ardm fork of dm-types"
  gem.description      = gem.summary
  gem.homepage         = "http://github.com/martinemde/ardm-types"
  gem.license          = "MIT"

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md]
  gem.require_paths    = [ "lib" ]

  gem.add_runtime_dependency 'ardm-core',   '~> 1.2'
  gem.add_runtime_dependency 'bcrypt',      '~> 3.0'
  gem.add_runtime_dependency 'fastercsv',   '~> 1.5'
  gem.add_runtime_dependency 'multi_json',  '~> 1.0'
  gem.add_runtime_dependency 'stringex',    '~> 1.3'
  gem.add_runtime_dependency 'uuidtools',   '~> 2.1'

  gem.add_development_dependency 'rake',  '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 2.0'
end
