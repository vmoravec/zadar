module Zadar
  module Libvirt
    class StoragePool
      def self.all
        Connection.list_all_storage_pools.map do |pool|
          new(pool)
        end
      end

      #name: 'default', type: 'dir', dirname: 'images', path: nil
      def self.define options={}
        raise "Path for storage pool missing" unless options[:path]

        template = Template.new(:pool, options)
      # Connection.define_storage_pool_xml(template.to_xml)
      end

      def initialize libvirt_pool
      end
    end
  end
end
