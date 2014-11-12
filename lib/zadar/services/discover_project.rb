module Zadar
  module Services
    class DiscoverProject < Service
      attr_reader :name, :project

      def initialize name
        @name = name
      end

      def call
        super do
          project_config = Rcfile.data.projects.find {|p| p[name]}
          report_error "Project with name '#{name}' not found in '.zadarrc' file" and return unless project_config

          if !Dir.exist?(project_config.path)
            report_error "Project not found in path #{project_config.path}" and return
          else
            @project = Project.detect(project_config)
          end
        end
      end
    end
  end
end
