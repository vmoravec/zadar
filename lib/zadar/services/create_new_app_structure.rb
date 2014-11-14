require 'active_record'

module Zadar
  module Services
    class CreateNewAppStructure < Service

      attr_reader :path
      attr_reader :db_dir

      def initialize path
        @path = path
        @db_dir = path.join('db')
      end

      def call
        super do
          create_db_dir
          create_db(copy_db_config)
          migrate_db
          create_iso_dir
        end
      end

      private

      def create_db_dir
        FileUtils.mkdir_p(db_dir)
      end

      def create_db config
        ActiveRecord::Base.configurations = ActiveRecord::Tasks::DatabaseTasks.database_configuration = YAML.load(File.read(config))
        ActiveRecord::Tasks::DatabaseTasks.db_dir = db_dir.to_s
        ActiveRecord::Tasks::DatabaseTasks.env = Zadar.env
        ActiveRecord::Tasks::DatabaseTasks.root = path
        ActiveRecord::Tasks::DatabaseTasks.current_config(config: ActiveRecord::Tasks::DatabaseTasks.database_configuration)
        Dir.chdir(db_dir) { ActiveRecord::Tasks::DatabaseTasks.create_current('production') }
      end

      def migrate_db
        begin
        require 'active_record_migrations'
        db_dir = self.db_dir
        ::ActiveRecordMigrations.configure do |c|
          c.db_dir = db_dir.to_s
          c.schema_format = :ruby
          c.yaml_config = db_dir.join("config.yml").to_path
          c.environment = ENV['ZADAR_ENV']
          c.migrations_paths = [Pathname.new(__dir__).join('../db/migrate').to_path] # the first entry will be used by the generator
puts 'vm'
        ActiveRecordMigrations.load_tasks
        Rake::Task['db:migrate'].execute
        end
        rescue => e
          puts e.message
          puts e.backtrace
        end
      end

      def copy_db_config
        config_dir = File.join(__dir__, "..", "db")
        config_file = Pathname.new(config_dir).join('config.yml')
        FileUtils.cp(config_file, db_dir.join('config.yml'))
        db_dir.join('config.yml')
      end

      def create_iso_dir
        FileUtils.mkdir(path.join('iso'))
        FileUtils.mkdir(path.join('iso').join('tmp'))
      end
    end
  end
end
