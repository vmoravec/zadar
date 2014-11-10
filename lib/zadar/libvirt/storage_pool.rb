module Zadar
  module Libvirt
    class StoragePool
      def self.find name
        find!(name)
      rescue ::Libvirt::RetrieveError
      end

      def self.find! name
        Connection.lookup_storage_pool_by_name(name)
      end

      def self.all
        Connection.list_all_storage_pools
      end

      #Options: name, type, path
      def self.define options={}
        raise "Path for storage pool missing" unless options[:path]

        template = Template.new(:pool, options)
        Connection.define_storage_pool_xml(template.to_xml)
      end

      def self.wipeout name
        pool = find!(name)
        pool.destroy if pool.active?
        pool.delete
        pool.undefine
        pool.free
      end
    end
  end
end
