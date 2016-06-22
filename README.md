# Redis SSDB Proxy [![Build Status](https://travis-ci.org/falm/redis-ssdb-proxy.svg?branch=master)](https://travis-ci.org/falm/redis-ssdb-proxy) [![Coverage Status](https://coveralls.io/repos/github/falm/redis-ssdb-proxy/badge.svg?branch=master)](https://coveralls.io/github/falm/redis-ssdb-proxy?branch=master)

The Redis SSDB Proxy that read from redis(or ssdb) write to both use for redis <=> ssdb migration on production

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis-ssdb-proxy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-ssdb-proxy

## Usage

If you want migrate redis data to SSDB the below code will write data to both of redis and ssdb and read from redis only

The options *ssdb: :slave* tells Proxy which redis-client is connected to the ssdb server which means Proxy will be delegating the unsupport data-structure (set) of SSDB to supported(zset)
```ruby
ssdb = Redis.new(host: 'localhost', port: '8888')
redis = Redis.new(host: 'localhost', port: '6379')

$redis = RedisSsdbProxy.new(master: redis, slave: ssdb, ssdb: :slave)

$redis.set(:quotes, 'May the force be with you') # set to both
$redis.get(:quotes) # read from master (redis)
# => May the force be with you 
```

When the data migrated the below line code will being prepare for the rollback

```ruby
$redis = RedisSsdbProxy.new(master: ssdb, slave: redis, ssdb: :master)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/falm/redis-ssdb-proxy.

## License
MIT © [Falm](https://github.com/falm)
