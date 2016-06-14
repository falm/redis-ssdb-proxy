# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis/ssdb/proxy/version'

Gem::Specification.new do |spec|
  spec.name          = "redis-ssdb-proxy"
  spec.version       = Redis::Ssdb::Proxy::VERSION
  spec.authors       = ["falm"]
  spec.email         = ["hjj1992@gmail.com"]

  spec.summary       = %q{proxy that read from redis(or ssdb) write to both use for redis <=> ssdb migration on production}
  spec.description   = %q{proxy that read from redis(or ssdb) write to both use for redis <=> ssdb migration on production}
  spec.homepage      = "https://github.com/falm/redis-ssdb-proxy"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end
  spec.licenses      = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
