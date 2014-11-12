require "zadar/version"
require "zadar/service"
require "zadar/libvirt"
require "zadar/rcfile"

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
  end
end
