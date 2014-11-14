module Zadar
  module Services
    class ImplodeProject < Service
      attr_reader :project_name, :project_path

      def initialize opts={}
        @project_name = opts[:name] || Zadar::DEFAULT_NAME
        @project_path = Pathname.new(Zadar::DEFAULT_PATH).join(project_name)
      end

      def call
        super do
          report_error("Project '#{project_name}' not found") and return unless File.exists?(project_path)

          #FIXME
          #Delete all volumes before removing the pool
          #Do not store any other files beside the libvirt volumes in that directory
          Libvirt::StoragePool.wipeout(project_name)
          FileUtils.rm_rf(project_path)
          Rcfile.data.projects.reject! {|p| p[project_name]}
          Rcfile.data.default_project = nil if Rcfile.data.default_project == project_name
          Rcfile.file.save

          report "Project #{project_name} has been successfuly purged from its location at #{project_path}"
        end
      end
    end
  end
end
