module Zadar
  module Services
    class FindMachines < Service
      attr_reader :project

      def initialize
        @project = Zadar.current_project
      end

      def call
        super do
          puts project.inspect
        end
      end
    end
  end
end
