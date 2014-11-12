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
          create_db
          copy_db_config
          create_iso_dir
        end
      end

      private

      def create_db_dir
        FileUtils.mkdir_p(db_dir)
      end

      def create_db
      end

      def copy_db_config
        config_dir = File.join(__dir__, "..", "..", "db")
        config_file = Pathname.new(config_dir).join('config.yml')
        FileUtils.cp(config_file, db_dir.join('config.yml'))
      end

      def create_iso_dir
        FileUtils.mkdir(path.join('iso'))
        FileUtils.mkdir(path.join('iso').join('tmp'))
      end
    end
  end
end
