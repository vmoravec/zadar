module Zadar
  module Services
    class FindLocalIsoRepos < Service
      attr_reader :repos

      def call
        super do
          @repos = Models::LocalIsoRepo.all
        end
      end
    end
  end
end
