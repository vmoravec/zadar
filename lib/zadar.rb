require 'sequel'
require 'libvirt'
require 'pathname'
require 'fileutils'
require 'forwardable'

require "zadar/version"
require "zadar/utils"
require "zadar/service"
require "zadar/libvirt"
require "zadar/rcfile"
require "zadar/project"
require "zadar/db"

module Zadar
  DEFAULT_NAME = "zadar"
  DEFAULT_DIR  = ".zadar/projects"
  DEFAULT_PATH = Pathname.new(Dir.home).join(DEFAULT_DIR)

  module Services; end

  class << self
    attr_reader :current_project
    attr_accessor :env
    attr_reader :local_user

    def initialize
      Zadar::Libvirt.connect
      Zadar::Rcfile.load
      @env = ENV['ZADAR_ENV'] || (Rcfile.any_content? && Zadar::Rcfile.data.environment) || 'production'
      @current_project = Project.detect
      @local_user = Utils::LocalUser.new
    end
  end
end
