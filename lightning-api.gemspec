lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lightning-api/version'

Gem::Specification.new do |spec|
  spec.name          = 'lightning-api'
  spec.version       = LightningApi::VERSION
  spec.authors = ['hypernova2002']
  spec.email = ['hypernova2002@gmail.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'https://github.com/hypernova2002/ligtning-api'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    # spec.metadata["homepage_uri"] = spec.homepage
    # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'puma'
  spec.add_dependency 'alba'
  spec.add_dependency 'hanami-api', '~>0.3'
  spec.add_dependency 'sequel'
  spec.add_dependency 'pg'
  spec.add_dependency 'pagy'
  spec.add_dependency 'zeitwerk'
  spec.add_dependency 'oj'
  spec.add_dependency 'guard'
  spec.add_dependency 'guard-puma'
  spec.add_dependency 'dry-cli'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-rootstrap'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'pry'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
