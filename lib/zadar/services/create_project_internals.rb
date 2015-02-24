module Zadar
  module Services
    class CreateProjectInternals < Service

      DB_DIR = "db"

      attr_reader :path, :name

      def initialize path, name
        @path = path
        @name = name
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
        puts "Creating dir #{path.join(DB_DIR)}"
        FileUtils.mkdir_p(path.join(DB_DIR))
      end

      def create_db
        puts "Creating database at #{path.join(DB_DIR, "#{Zadar.env}.sqlite3")}"
        SQLite3::Database.new(path.join(DB_DIR, "#{Zadar.env}.sqlite3").to_s)
      end

      def load_schema
        puts "Running migrations..."
        project = Project.detect(name)
        migration_dir = Pathname.new(__dir__).join("..", "db", "migrate")
        Sequel.extension :migration
        Sequel::Migrator.run(project.db.connection, migration_dir)
        puts "Migrations done"
      end

      def create_iso_dir
        FileUtils.mkdir(path.join('iso'))
      end

      def create_images_dir;    end
      def create_snapshots_dir; end
    end
  end
end
