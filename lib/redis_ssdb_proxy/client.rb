
module RedisSsdbProxy

  class Client

    attr_accessor :master, :slave

    def initialize(args)
      self.master, self.slave = args.fetch(:master), args.fetch(:slave)
      Delegator.call(self, args[:ssdb])
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

      def send_to_both(command)
        class_eval <<-EOS
          def #{command}(*args, &block)
            slave.#{command}(*args, &block)
            master.#{command}(*args, &block)
          end
        EOS
      end
    end

    %i(dbsize exists get getbit getrange hexists hget hgetall hkeys hlen hmget hvals keys lindex llen lrange mget
    randomkey scard sdiff sinter sismember smembers sort srandmember strlen sunion ttl type zcard zcount zrange
    zrangebyscore zrank zrevrange zscore).each do |command|
      send_to_master command
    end

    # all write opreate send to master slave both
    def method_missing(name, *args, &block)
      if master.respond_to?(name)
        self.class.send(:send_to_both, name)
        slave.send(name, *args, &block)
        master.send(name, *args, &block)
      else
        super
      end
    end


  end # Client

end # RedisSsdbProxy
