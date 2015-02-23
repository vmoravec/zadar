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
          create_db
          load_schema
          create_iso_dir
          create_images_dir
          create_snapshots_dir
        end
      end

      private

      def create_db_dir
        puts "Creating dir #{db_dir}"
        FileUtils.mkdir_p(db_dir)
      end

      def create_db
        puts "Creating database at #{db_dir.join("#{Zadar.env}.sqlite3")}"
        SQLite3::Database.new(db_dir.join("#{Zadar.env}.sqlite3").to_s)
      end

      #TODO
      def load_schema config, schema_file
        puts "Run migrations to create the tables"
          Pathname.new(__dir__).join("..", "db", "schema.rb")
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
