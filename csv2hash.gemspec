require_relative 'lib/csv2hash/version'

Gem::Specification.new do |spec|
  spec.name        = 'csv2hash'
  spec.version     = Csv2hash::VERSION
  spec.date        = '2013-11-26'
  spec.summary     = %q{Mapping a CSV to a Ruby Hash}
  spec.description = %q{DSL to map a CSV to a Ruby Hash}
  spec.authors     = ['Joel AZEMAR']
  spec.email       = 'joel.azemar@gmail.com'
  spec.files       = ['lib/csv2hash.rb']
  spec.homepage    = 'https://github.com/joel/csv2hash'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.1'

  spec.add_development_dependency 'bundler', '> 1.3'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'its', '~> 0.2'
end
