require 'spec_helper'


describe RedisSsdbProxy do

  let(:redis_to_ssdb_proxy) { RedisSsdbProxy.new(master: @redis, slave: @ssdb, ssdb: :slave) }

  let(:ssdb_to_redis_proxy) { RedisSsdbProxy.new(master: @ssdb, slave: @master, ssdb: :master) }

  before(:each) do
    @redis.set(:lines, "I'll be back")
  end

  it 'should works' do
    @redis.set(:name, 'Tom')
    expect(redis_to_ssdb_proxy.get(:name)).to eq(@redis.get(:name))
  end

  it 'should read from master' do
    expect(redis_to_ssdb_proxy.master).to receive(:get)
    redis_to_ssdb_proxy.get(:lines)
  end


end
