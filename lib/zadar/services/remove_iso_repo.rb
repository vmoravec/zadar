module Zadar
  module Services
    class RemoveIsoRepo < Service
      attr_reader :name, :repo
      attr_reader :delete

      def initialize options
        @delete = !!options[:"delete"]
        @name = options[:name]
        failure! "Repository name not specified" if name.to_s.empty?

        @repo = Models::IsoRepo.find(name: name)
        failure! "Repo with name '#{name}' not found" unless repo
      end

      def call
        super do
          FileUtils.rm_rf(repo.path) if delete
          repo.destroy
          report "Iso repository '#{repo.name}' has been removed"
        end
      end
    end
  end
end
