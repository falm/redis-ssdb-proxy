
module RedisSsdbProxy

  class Client

    attr_accessor :master, :slave

    def initialize(args)
      sellf.master, self.slave = args.fetch(:master), args.fetch(:slave)
      if [:master, :slave].include? args[:ssdb]
        delegate_ssdb_unsupport self.send(args[:ssdb])
      end
    end

    def delegate_ssdb_unsupport(redis_client)
      redis_client.instance_eval do
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

    class << self
      private
      def send_to_slave(command)
        class_eval <<-EOS
          def #{command}(*args, &block)
            slave.#{command}(*args, &block)
          end
        EOS
      end

      def send_to_master(command)
        class_eval <<-EOS
          def #{command}(*args, &block)
            master.#{command}(*args, &block)
          end
        EOS
      end

    end


    send_to_master :dbsize
    send_to_master :exists
    send_to_master :get
    send_to_master :getbit
    send_to_master :getrange
    send_to_master :hexists
    send_to_master :hget
    send_to_master :hgetall
    send_to_master :hkeys
    send_to_master :hlen
    send_to_master :hmget
    send_to_master :hvals
    send_to_master :keys
    send_to_master :lindex
    send_to_master :llen
    send_to_master :lrange
    send_to_master :mget
    send_to_master :randomkey
    send_to_master :scard
    send_to_master :sdiff
    send_to_master :sinter
    send_to_master :sismember
    send_to_master :smembers
    send_to_master :sort
    send_to_master :srandmember
    send_to_master :strlen
    send_to_master :sunion
    send_to_master :ttl
    send_to_master :type
    send_to_master :zcard
    send_to_master :zcount
    send_to_master :zrange
    send_to_master :zrangebyscore
    send_to_master :zrank
    send_to_master :zrevrange
    send_to_master :zscore
  


  end # Client

end # RedisSsdbProxy
