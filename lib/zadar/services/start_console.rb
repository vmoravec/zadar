module Zadar
  module Services
    class StartConsole < Service
      attr_reader :main

      def initialize options
        Zadar.env = options[:env] if options[:env]
        @main = options[:main]
      end

      def call
        super do
          failure! "No project found, console not available" unless Zadar.current_project

          require 'irb'
          IRB.start
        end
      end
    end
  end
end
