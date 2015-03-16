require 'zadar/services/detect_iso_remote_type'
require 'zadar/adapters/remote_iso_repo'

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
          repo_type = Services::DetectIsoRemoteType.new(url: url).call.type
          report "Detected repository type '#{repo_type}'"
          remote = Adapters::RemoteIsoRepo.new(type: repo_type.to_s, url: url).validate!
          new_repo = create_new_repo(repo_type)
          remote.files.each do |file|
            Models::IsoFile.create(file.to_h.merge(iso_repo: new_repo))
          end
          report "Repository '#{name}' has been created successfuly"
          report "#{remote.files.size} files has been detected"
        end
      end

      private

      def create_new_repo repo_type
        path = File.join(Zadar.current_project.path, 'iso', name)
        failure! "Repo directory already exists" if Dir.exist?(path)

        new_repo = Models::IsoRepo.create(url: url, name: name, type: repo_type, local_path: path)
        FileUtils.mkdir_p(path)
        new_repo
      end
    end
  end
end
