module Zadar
  module Services
    class FindProjectVolumes < Service
      attr_reader :project

      def initialize
        @project = Project.detect
      end

      def call
        super do
          project.establish_database_connection
          #TODO
          #find volumes ? btw is this a correct approach?
          #I mean we are going to work with images, machines, snapshots so on, talking
          #about volumes is a libvirt terminology..
        end
      end
    end
  end
end
