module Zadar
  module Services
    class StartConsole < Service
      def call
        super do
          require 'irb'
          IRB.start
        end
      end
    end
  end
end
