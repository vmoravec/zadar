module Zadar
  module Services
    class FindIsoFiles < Service
      attr_reader :repo, :files

      def initialize options
        @repo = Models::IsoRepo.find(name: options[:repo])
        failure! "Repository with name '#{repo}' not found" unless repo
      end

      def call
        super do
          @files = repo.files
        end
      end
    end
  end
end
