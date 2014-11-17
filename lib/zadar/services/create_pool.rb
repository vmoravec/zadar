module Zadar
  module Services
    class CreatePool < Service
      DEFAULT_TYPE = 'dir'
      POOL_DIR     = 'storage'

      attr_reader :name, :type, :path, :user

      def initialize options={}
        @name = options[:name]
        raise "Missing pool name" unless name || name.to_s.empty?

        @type = options[:type] || DEFAULT_TYPE
        @path = options[:path].join(POOL_DIR)
        raise "Path not defined for pool '#{name}'" unless path

        @user = options[:user] || Zadar.local_user

      end

      def call
        super do
          pool = Libvirt::StoragePool.define(name: name, path: path, type: type, user: user)
          pool.build
        end
      end
    end
  end
end
