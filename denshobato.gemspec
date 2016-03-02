# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'denshobato/version'

Gem::Specification.new do |spec|
  spec.name          = 'denshobato'
  spec.version       = Denshobato::VERSION
  spec.authors       = ['ID25']
  spec.email         = ['xid25x@gmail.com']

  spec.summary       = 'Denshobato - private messaging between models'
  spec.description   = 'Denshobato - private messaging between models'
  spec.homepage      = 'https://github.com/ID25/denshobato'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '>= 3.2.0'
  spec.add_runtime_dependency 'grape'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_girl', '~> 4.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 3.1'
end
