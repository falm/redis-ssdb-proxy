
module RedisSsdbProxy

  attr_accessor :master, :slave

  class Client

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

  end # Client

end # RedisSsdbProxy
