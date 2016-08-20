require 'rspec'
require 'redis'
require 'redis-namespace'
require 'redis-ssdb-proxy'
require 'dotenv'
require 'coveralls'

Coveralls.wear!

Dotenv.load

redis_host, redis_port = (ENV['redis_host'] || 'localhost'), (ENV['redis_port'] || 6379)
ssdb_host, ssdb_port = (ENV['ssdb_host'] || 'localhost'), (ENV['ssdb_port'] || 8888)
$redis = Redis::Namespace.new :redis_test, redis: Redis.new(host: redis_host, port: redis_port)
$ssdb = Redis::Namespace.new :ssdb_test, redis: Redis.new(host: ssdb_host, port: ssdb_port)

RSpec.configure do |config|

  config.before(:example) do
    @redis = $redis
    @ssdb = $ssdb
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end