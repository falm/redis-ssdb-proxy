module RedisSsdbProxy

  class Delegator

    attr_accessor :client

    def self.call(client, role)
      if [:master, :slave].include? role
        self.new(client.send(role)).delegate
      end
    end

    def initialize(client)
      self.client = client
    end

    def delegate
      delegate_nonsupport_method
    end

    def delegate_nonsupport_method
      client.instance_eval do
        def sadd(key, *args)
          zadd(key, args.map{ |arg|
            [Time.now.to_i, arg]
          })
        end

        def srem(*args)
          zrem(*args)
        end
      end
    end

  end

end
