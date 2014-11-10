require 'forwardable'

module Zadar
  module Libvirt
    class StoragePool
      extend Forwardable

      def self.find name
        find!(name)
      rescue ::Libvirt::RetrieveError
      end

      def self.find! name
        new(Connection.lookup_storage_pool_by_name(name))
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
        pool.purge!
      end

      def_delegators :@libvirt_pool, :create, :destroy, :delete, :free, :active?,
                                     :undefine, :xml_desc

      attr_reader :xml, :path, :name

      def initialize libvirt_pool
        @libvirt_pool = libvirt_pool
        xml_doc = Nokogiri::XML(xml_desc)
        @path = xml_doc.xpath("//target/path").text
        @name = xml_doc.xpath("//name").text
      end

      def purge!
        destroy if active?
        delete  if File.exists?(path)
        undefine
        free
      end
    end
  end
end
