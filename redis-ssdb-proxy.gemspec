# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_ssdb_proxy/version'

Gem::Specification.new do |spec|
  spec.name          = "redis-ssdb-proxy"
  spec.version       = RedisSsdbProxy::VERSION
  spec.authors       = ["falm"]
  spec.email         = ["hjj1992@gmail.com"]

  spec.summary       = %q{proxy that read from redis(or ssdb) write to both use for redis <=> ssdb migration on production}
  spec.description   = %q{proxy that read from redis(or ssdb) write to both use for redis <=> ssdb migration on production}
  spec.homepage      = "https://github.com/falm/redis-ssdb-proxy"

  spec.licenses      = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'redis'
  spec.add_development_dependency 'redis-namespace'
  spec.add_development_dependency 'dotenv'

end
