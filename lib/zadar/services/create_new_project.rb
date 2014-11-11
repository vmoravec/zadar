require 'etc'
require 'zadar/services/create_new_app_structure'

module Zadar
  module Services
    class CreateNewProject < Service
      attr_reader :name

      attr_reader :path, :user

      def initialize options
        @user = detect_user
        @name = options[:name] || Zadar::DEFAULT_NAME
        @path = options[:path] ? Pathname.new(options[:path]).join(name) : Zadar::DEFAULT_PATH.join(name)
      end

      def call
        super do
          if File.exist?(path.to_path)
            report_error "Project with name '#{name}' already exists"
            return
          end

          create_project_dir
          pool = define_pool
          pool.build

          app_structure_task = CreateNewAppStructure.new(path)
          tasks << app_structure_task.call

          report "New project in with path #{path} has been created"
        end
      end

      private

      def create_project_dir
        FileUtils.mkdir_p(path.to_path)
      end

      def define_pool
        Libvirt::StoragePool.define(name: name, path: path.join('images'), type: 'dir', user: user)
      end

      def detect_user
        login = Etc.getlogin
        info  = Etc.getpwnam(login)
        OpenStruct.new(id: info.uid, gid: info.gid)
      end
    end
  end
end
