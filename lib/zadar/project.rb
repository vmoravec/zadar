require 'ostruct'
require 'logger'

module Zadar
  class Project
    DB_DIR = 'db'
    DB_LOG_DIR = 'log'
    DB_LOG_FILENAME = 'database.log'

    def self.detect name=nil, new=false
      return if Rcfile.content_empty?
      name = Rcfile.data.default_project if name.nil?
      project_config = Rcfile.data.projects.find {|project| project[name]}
      return if project_config.nil?

      path = Pathname.new(project_config[name].path)
      return unless Dir.exist?(path)
      new(path, name)
    end

    attr_reader :path, :db, :name, :model, :connection

    def initialize path, name
      @name = name
      @path = path
      @db = OpenStruct.new
      db.dir = Zadar::Db.dir = path.join(DB_DIR)
      db.migrations_dir = path.join(db.dir, 'migrate')
      db.log_file = path.join(DB_LOG_DIR, DB_LOG_FILENAME)
      db.logger = ::Logger.new(File.open(db.log_file, 'a'))
      db.file = db.dir.join("#{Zadar.env}.sqlite3").to_s
      @connection = connect_to_database
      #@model = Models::Project.find_by(name: name)
    end

    def connect_to_database
      conn = Sequel.connect("sqlite:#{db.file}", loggers: [db.logger])
      Zadar.instance_variable_set(:@current_project, self)

      require 'zadar/models'

      conn
    end
  end
end
