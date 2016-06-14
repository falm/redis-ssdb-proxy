
Gem.find_files('redis_ssdb_proxy/**/*.rb').each { |file| require file }

module RedisSsdbProxy

  def self.new(*args)
    Client.new(*args)
  end
end
