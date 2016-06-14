
Gem.find_files('/lib/**/*.rb') { |f| require 'f'}

module RedisSsdbProxy

  def self.new(*args)
    Client.new(*args)  
  end
end
