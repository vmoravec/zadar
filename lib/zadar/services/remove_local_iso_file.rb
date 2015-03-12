module Zadar
  module Services
    class RemoveLocalIsoFile < Service
      attr_reader :file, :repo, :delete

      def initialize options
        failure! "Iso repository name is missing" if options[:repo].to_s.empty?
        failure! "Iso filename is missing" if options[:filename].to_s.empty?

        @delete = options[:delete]
        @repo = Models::LocalIsoRepo.find(name: options[:repo])
        @file = repo.iso_local_files_dataset.where(filename: options[:filename]).first

        failure! "Iso file not found" unless file
      end

      def call
        super do
          FileUtils.rm(file.full_path) if delete
          file.destroy
          report "Iso file #{file.full_path} from repository '#{repo.name}' has been deleted"
        end
      end
    end
  end
end

