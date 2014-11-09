module Zadar
  module Libvirt
    class StoragePool
      def self.all
        Connection.list_all_storage_pools.map do |pool|
          new(pool)
        end
      end

      def initialize libvirt_pool
      end
    end
  end
end
