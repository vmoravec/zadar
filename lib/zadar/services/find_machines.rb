module Zadar
  module Services
    class FindMachines < Service
      attr_reader :project, :machines

      def initialize
        @project = Zadar.current_project
        @machines = []
      end

      def call
        super do
          if Models::Machine.count.zero?
            report "No machines found for project '#{project.model.name}'"
          else
            @machines = Models::Machine.all
          end
        end
      end
    end
  end
end
