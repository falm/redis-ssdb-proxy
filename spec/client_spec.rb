require 'spec_helper'


describe RedisSsdbProxy do

  let(:redis_to_ssdb_proxy) { RedisSsdbProxy.new(master: @redis, slave: @ssdb, ssdb: :slave) }

  let(:ssdb_to_redis_proxy) { RedisSsdbProxy.new(master: @ssdb, slave: @master, ssdb: :master) }

  before(:each) do
    @redis.set(:lines, "I'll be back")
  end

  it 'should works' do
    redis_to_ssdb_proxy.set(:name, 'Tom')
    expect(redis_to_ssdb_proxy.get(:name)).to eq(@redis.get(:name))
  end

  it 'should read from master' do
    expect(redis_to_ssdb_proxy.master).to receive(:get)
    redis_to_ssdb_proxy.get(:lines)
  end

  it 'should write to redis and ssdb' do
    args = [:quotes, 'starwars']
    redis_to_ssdb_proxy.hset( *(args + ['May the force be with you']) )
    expect(@redis.hget(*args)).to eq(@ssdb.hget(*args))
  end

  it 'delagate set to zset' do
    quotes = ["I'm your father", "Thats's no moon", 'Use the force, Luke']
    key = "#{rand(20)}_quotes_of_star_wars"
    quotes.each { |q| redis_to_ssdb_proxy.sadd(key, q) }
    result = @ssdb.zrange(key, 0, -1)
    expect(result).to eq(quotes)
  end


end
