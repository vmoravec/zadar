require 'pathname'
require 'erb'
require 'ostruct'

module Zadar
  module Libvirt
    class Template
      EXTENSION = '.xml.erb'
      DIR_NAME = Pathname.new(__dir__).join("templates")

      attr_reader :file, :xml, :options

      def initialize type, opts={}
        @file = DIR_NAME.join(type.to_s + EXTENSION)
        @options = OpenStruct.new(opts)
        raise "Template '#{type}' does not exist" unless File.exists?(file)

        erb = ERB.new(File.read(file))
        @xml = erb.result(binding)
      end

      def to_xml
        xml
      end
    end
  end
end
