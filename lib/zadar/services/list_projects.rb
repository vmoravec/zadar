module Zadar
  module Services
    class ListProjects < Service
      def call
        super do
          report "Projects..."
        end
      end
    end
  end
end
