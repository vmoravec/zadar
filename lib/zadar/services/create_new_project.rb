module Zadar
  module Services
    class CreateNewProject < Service
      attr_reader :name

      attr_reader :path

      def initialize options
        @name = options[:name] || Zadar::DEFAULT_NAME
        @path = options[:path] || Zadar::DEFAULT_PATH
      end

      def call
        super do
          if File.exist?(path.join(name).to_path)
            failure! "Project with name '#{name}' already exists"
          end

          create_project_dir
          pool = define_pool
          pool.build
          pool.create

          report "New project in with path #{path.join(name)} has been created"
        end
      end

      private

      def create_project_dir
        FileUtils.mkdir_p(path.join(name).to_path)
      end

      def define_pool
        Libvirt::StoragePool.define(name: name, path: path.join(name).join('images'), type: 'dir')
      end
    end
  end
end
