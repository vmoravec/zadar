module Zadar
  module Services
    class StartConsole < Service
      def initialize options
        Zadar.env = options[:env] if options[:env]
      end

      def call
        super do
          require 'irb'
          IRB.start
        end
      end
    end
  end
end
