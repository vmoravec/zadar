module Zadar
  module Services
    class AddLocalIsoFile < Service
      attr_reader :repo, :filename, :name

      def initialize options
        @name = options[:name]
        @filename = options[:filename]
        failure! "Filename is mandatory" if filename.to_s.empty?

        @repo = Models::IsoRepo.find(name: options[:repo])
        failure! "Repository '#{options[:repo]}' not found" unless repo
      end

      def call
        super do
          new_file = Models::IsoLocalFile.create(iso_repo: repo, filename: filename, name: name)
          report "Iso file at #{new_file.full_path} has added to repository '#{repo.name}'"
        end
      end
    end
  end
end
