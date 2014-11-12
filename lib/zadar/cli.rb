require 'zadar'
require 'zadar/cli/command'

module Zadar
  module Cli
    def self.run
      @command = Command.new(ARGV)
      command.load
    end

    def self.command
      @command
    end

    module Dsl
      def zadar &block
        Cli.command.dsl(&block)
      end
    end
  end
end

self.extend(Zadar::Cli::Dsl)

Zadar.initialize
