require "zadar/version"
require "zadar/service"
require "zadar/libvirt"
require "zadar/rcfile"
require "zadar/project"
require "zadar/db"

require 'libvirt'
require 'pathname'
require 'fileutils'

module Zadar
  DEFAULT_NAME = "zadar"
  DEFAULT_DIR  = ".zadar/projects"
  DEFAULT_PATH = Pathname.new(Dir.home).join(DEFAULT_DIR)

  module Services; end

  def self.initialize
    Zadar::Libvirt.connect
    Zadar::Rcfile.load
    Zadar::Db.dir = current_project.db_dir if current_project
    Zadar.env = ENV['ZADAR_ENV'] || Zadar::Rcfile.data.environment || 'production'
  end

  def self.current_project
    @current_project
  end

  def self.detect_project path
    @current_project = Project.detect(path)
  end

  def self.env
    @env
  end

  def self.env= environment
    @env = environment
  end
end
