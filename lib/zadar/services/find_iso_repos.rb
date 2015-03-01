module Zadar
  module Services
    class FindIsoRepos < Service
      attr_reader :repos

      def call
        super do
          @repos = Models::IsoRepo.all
        end
      end
    end
  end
end
