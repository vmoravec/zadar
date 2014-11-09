require 'pathname'

module Zadar
  module Libvirt
    class Template
      EXTENSION = '.xml.erb'
      DIR_NAME = Pathname.new(__dir__).join("templates")

      attr_reader :file

      def initialize type, options={}
        @file = DIR_NAME.join(type.to_s + EXTENSION)
        raise "Template '#{type}' does not exist" unless File.exists?(file)

        puts file
      end
    end
  end
end
