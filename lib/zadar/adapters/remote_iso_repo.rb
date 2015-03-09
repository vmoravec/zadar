module Zadar
  module Adapters
    def self.register type, klass
      registered.merge!(type => klass)
    end

    def self.registered
      @registered ||= {}
    end

    class RemoteIsoRepo
      extend Forwardable

      def_delegators :@adapter, :connection, :files, :validate!

      attr_reader :url

      def initialize options
        @url = options[:url]
        @adapter = detect_adapter(options[:type]).new(url)
      end

      private

      def detect_adapter type
        adapter = Adapters.registered[type]
        raise "Adapter '#{type}' not found" unless adapter

        adapter
      end
    end

    RemoteIsoStruct = Struct.new(:url, :mirror, :filename, :size, :mtime, :md5, :sha1, :sha256)


    register 'opensuse', Opensuse
  end
end
