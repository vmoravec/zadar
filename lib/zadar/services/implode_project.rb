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
          failure!("Project '#{project_name}' not found") unless File.exists?(project_path)

          Libvirt::StoragePool.wipeout(project_name)
          FileUtils.rm_rf(project_path)
        end
      end
    end
  end
end