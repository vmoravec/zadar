require 'ostruct'
require 'active_record'
class User < ActiveRecord::Base
end

module Zadar
  class Project
    DB_DIR = 'db'
    DB_LOG_DIR = 'log'
    DB_LOG_FILENAME = 'database.log'
    SQLITE3_DATABASE_FILE = 'production.sqlite3'
    DB_CONFIG_FILE = 'config.yml'

    def self.detect name=nil
      name = Rcfile.data.default_project if name.nil?
      project_config = Rcfile.data.projects.find {|project| project[name]}
      return if project_config.nil?

      path = Pathname.new(project_config[name].path)
      return unless Dir.exist?(path)

      new(path)
    end

    attr_reader :path, :db

    def initialize path
      @path = path
      @db = OpenStruct.new
      db.dir = path.join(DB_DIR)
      db.migrations_dir = path.join(db.dir, 'migrate')
      db.config_file = path.join(db.dir, DB_CONFIG_FILE)
      db.log_file = path.join(DB_LOG_DIR, DB_LOG_FILENAME)
    end

    def establish_database_connection
      content = YAML.load_file(db.config_file)[Zadar.env]
      content['database'] = db.dir.join(SQLITE3_DATABASE_FILE)
      ActiveRecord::Base.establish_connection(content)
      ActiveRecord::Base.logger = Logger.new(File.open(db.log_file, 'a'))
    end
  end
end
