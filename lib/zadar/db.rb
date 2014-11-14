module Zadar
  class Db
    class << self
      attr_accessor :dir

      attr_accessor :loaded

      def load
        raise "Database configuration dir is missing" unless dir
        load_configuration
      end

      private

      def migrations_dir
        @migrations_dir ||= Pathname.new(__dir__).join('db/migrate')
      end

      def schema_file
        @schema_file ||= dir.join("schema.rb")
      end

      def load_configuration
        require 'active_record_migrations'

        dir = self.dir

        ActiveRecordMigrations.configure do |c|
          c.db_dir = dir.to_s
          c.schema_format = :ruby
          c.yaml_config = dir.join("config.yml").to_path
          c.environment = ENV['ZADAR_ENV']
          c.migrations_paths = [dir.join('migrate').to_path] # the first entry will be used by the generator
        end

        ActiveRecordMigrations.load_tasks

        self.loaded = true
      end
    end
  end
end
