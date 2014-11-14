module Zadar
  module Services
    class DetectProjectPath < Service
      attr_reader :project_name, :project_path

      def initialize project_name=nil
        @project_name = project_name || Rcfile.data.default_project
      end

      def call
        return self unless project_name

        super do
          project_config = Rcfile.data.projects.find {|p| p[project_name]}
          if project_config.nil?
            report_error "Project with name '#{project_name}' not found in '.zadarrc' file"
            return
          end

          if !Dir.exist?(project_config[project_name].path)
            report_error "Project not found in path #{project_config.path}"
            return
          else
            @project_path = project_config[project_name].path
          end
        end
      end
    end
  end
end
