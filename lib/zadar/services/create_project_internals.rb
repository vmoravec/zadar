require 'active_record'

module Zadar
  module Services
    class CreateProjectInternals < Service

      attr_reader :path
      attr_reader :db_dir

      def initialize new_project_path
        @path = new_project_path
        @db_dir = path.join('db')
      end

      def call
        super do
          create_db_dir
          production_db_config = YAML.load(File.read(copy_db_config))
          create_db(production_db_config)
          schema_file = Pathname.new(__dir__).join("..", "db", "schema.rb").to_s
          load_schema(production_db_config, schema_file)
          create_iso_dir
        end
      end

      private

      def create_db_dir
        FileUtils.mkdir_p(db_dir)
      end

      def create_db config
        config['production']['database'] = db_dir.join('production.sqlite3').to_s
        ActiveRecord::Base.logger = Logger.new(File.open(path.join('log', 'database.log'), 'a'))
        ActiveRecord::Base.configurations = ActiveRecord::Tasks::DatabaseTasks.database_configuration = config
        ActiveRecord::Tasks::DatabaseTasks.db_dir = db_dir.to_s
        ActiveRecord::Tasks::DatabaseTasks.env = Zadar.env
        ActiveRecord::Tasks::DatabaseTasks.root = path
        ActiveRecord::Tasks::DatabaseTasks.current_config(config: ActiveRecord::Tasks::DatabaseTasks.database_configuration)
        Dir.chdir(db_dir) { ActiveRecord::Tasks::DatabaseTasks.create_current('production') }
      end

      def load_schema config, schema_file
        ActiveRecord::Tasks::DatabaseTasks.load_schema(:ruby, schema_file)
      end

      def copy_db_config
        config_dir = File.join(__dir__, "..", "db")
        config_file = Pathname.new(config_dir).join('production.config.yml')
        FileUtils.cp(config_file, db_dir.join('config.yml'))
        db_dir.join('config.yml').to_s
      end

      def create_iso_dir
        FileUtils.mkdir(path.join('iso'))
        FileUtils.mkdir(path.join('iso').join('tmp'))
      end
    end
  end
end
