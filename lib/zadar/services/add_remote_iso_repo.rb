module Zadar
  module Services
    class AddRemoteIsoRepo < Service
      attr_reader :name, :url

      def initialize options
        @name = options[:name].to_s
        @url  = options[:url].to_s

        failure! "Remote iso repository name is missing" if name.empty?
        failure! "Remote iso repository url is missing"  if url.empty?
      end

      def call
        super do
          # 1. Detect what kind of repo it is (sles, opensuse, debian, fedora, susecloud),
          #    look at the url to find this out or add flag :type
          # 2. Select the correct adapter for parsing the url (todo: create an abstract class
          #    with methods that will need implementation from the adapter objects)
          # 2.1 Use the adapter and run tests and checks -> fail if these does not succeed
          #     Don't save any results from the tests into the database yet.(includes parsing
          #     the html data into database)
          # 2.1 Localy create a new dir for this iso repository for files that might be
          #    needed from the adapter
          # 3. Apply the adapter on the url -> save the extracted data into db and on disk
          report "Repository '#{name}' has been created successfuly"
        end
      end
    end
  end
end
