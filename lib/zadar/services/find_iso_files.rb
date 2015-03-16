module Zadar
  module Services
    class FindIsoFiles < Service
      attr_reader :files, :repo

      def initialize options
        @repo_name = options[:repo_name]
        failure! "Please specify name of the repository" unless options[:repo_name]
        @repo = Models::RemoteIsoRepo.find(name: options[:repo_name])
        failure! "Repository not found" unless repo
      end

      def call
        super do
          @files = repo.files
        end
      end
    end
  end
end
