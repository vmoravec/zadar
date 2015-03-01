require 'etc'

require 'zadar/db/seeds'
require 'zadar/services/create_pool'
require 'zadar/services/create_project_internals'

module Zadar
  module Services
    class CreateNewProject < Service
      attr_reader :name

      attr_reader :path, :user, :rcfile, :seeds

      def initialize options
        @user = Zadar.local_user
        @name = options[:name] || Zadar::DEFAULT_NAME
        @path = options[:path] ? Pathname.new(options[:path]).join(name) : Zadar::DEFAULT_PATH.join(name)
        @rcfile = Rcfile.create(project_name: name, project_path: path.to_s)
        @seeds = Seeds.seed_new_project(name: name, path: path.to_s)
      end

      def call
        super do
          rcfile.save
          if File.exist?(path.to_path)
            failure! "Project with name '#{name}' already exists in path #{path}"
          end
          create_project_dir
          super(CreatePool.new(name: name, path: path, user: user))
          create_log_dir
          super(CreateProjectInternals.new(path, name))
          seeds.seed!
          report "New project in with path #{path} has been created"
        end
      end

      private

      def create_project_dir
        FileUtils.mkdir_p(path.to_path)
      end

      def create_log_dir
        FileUtils.mkdir(path.join('log'))
      end
    end
  end
end
