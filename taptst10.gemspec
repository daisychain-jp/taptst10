# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taptst10/version'

Gem::Specification.new do |spec|
  spec.name          = "taptst10"
  spec.version       = Taptst10::VERSION
  spec.authors       = ["INAMORI Takayuki"]
  spec.email         = ["t.inamori@daisychain.jp"]

  spec.summary       = %q{Library for accessing TAP-TST10, SANWA SUPPLY watt monitor.}
  spec.description   = %q{Application can send and receive command and get all watt data records..}
  spec.homepage      = "https://github.com/daisychain173/taptst10"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "libusb"
  spec.add_dependency "thor"
end
