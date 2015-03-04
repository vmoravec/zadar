module Zadar
  module Services
    class FindLocalIsoFiles < Service
      attr_reader :repo, :files

      def initialize options
        @repo = Models::LocalIsoRepo.find(name: options[:repo])
        failure! "Repository with name '#{options[:repo]}' not found" unless repo
      end

      def call
        super do
          @files = repo.files
        end
      end
    end
  end
end
