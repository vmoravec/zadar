module Zadar
  module Services
    class CreateNewProject < Service
      DEFAULT_NAME = "default"
      DEFAULT_DIR  = ".zadar/projects"
      DEFAULT_PATH = Pathname.new(Dir.home).join(DEFAULT_DIR)

      attr_reader :name

      attr_reader :path

      def initialize options
        @name = options[:name] || DEFAULT_NAME
        @path = options[:path] || DEFAULT_PATH
      end

      def call
        super do
          if File.exist?(path.join(name).to_path)
            failure! "Project with name '#{name}' already exists"
          end

          create_project_dir
          create_pool

          report "New project in with path #{path.join(name)} has been created"
        end
      end

      private

      def create_project_dir
        FileUtils.mkdir_p(path.join(name).to_path)
      end

      def create_pool
        Libvirt::StoragePool.define(dirname: 'images', path: path)
      end
    end
  end
end
