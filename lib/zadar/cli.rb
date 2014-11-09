require 'gli'

require 'zadar'

module Zadar
  class Cli
    include GLI::App

    def self.run argv
      new(argv)
    end

    def initialize argv
    end
  end
end
