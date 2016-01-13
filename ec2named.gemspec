# encoding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ec2named/version'

Gem::Specification.new do |s|
  s.name          = "ec2named"
  s.version       = Ec2named::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Alan Norton"]
  s.email         = ["me@alannorton.com"]

  s.summary       = 'Quickly find and print information about EC2 instances you can describe.'
  s.description   = 'Primarily used to find private IP addresses of instances'
  s.homepage      = "https://github.com/nonrational/ec2named"
  s.license       = "MIT"

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.travis.yml
    |run
    |install
    |\.ruby-version
    |.*\.eps
    )$}x
  end
  s.bindir          = "bin"
  s.executables     = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md', 'CODE_OF_CONDUCT.md']

  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = "http://gems.nonrational.org"
  end

  s.add_dependency "aws-sdk", "~> 2.2"
  s.add_dependency "json"
  s.add_dependency "trollop"

  s.add_development_dependency "bundler", "~> 1.8"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "pry-byebug"
end
