module Zadar
  module Services
    class AddNewIsoRepo < Service
      attr_reader :path, :name

      def initialize options
        @path = Pathname.new(options[:path]).expand_path.to_s
        @name = options[:name]
      end

      def call
        super do
          Models::IsoRepo.create(path: path, name: name)
          report "New iso repository has been created"
        end
      end
    end
  end
end
