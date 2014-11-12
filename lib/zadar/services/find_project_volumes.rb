require 'zadar/services/discover_project'

module Zadar
  module Services
    class FindProjectVolumes < Service
      attr_reader :project

      def initialize options
        @project_name = options[:project] || Rcfile.data.default_project || raise "Project not detected"
      end

      def call
        super do
          discover_task = DiscoverProject.new(project_name)
          services << discover_task.call
          @project = discover_task.project
        end
      end
    end
  end
end
