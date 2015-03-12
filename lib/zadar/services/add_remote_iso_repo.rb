require 'zadar/services/detect_iso_remote_type'
require 'zadar/adapters/remote_iso_repo'
require 'zadar/adapters/opensuse'

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
          remote = Adapters::RemoteIsoRepo.new(type: repo_type.to_s, url: url)
          remote.validate!
          new_repo = Models::RemoteIsoRepo.create(url: url, name: name)
          create_repo_dir(new_repo)
          remote.files.each do |file|
            Models::RemoteIsoFile.create(file.to_h.merge(:remote_iso_repo: new_repo))
          end
          report "Repository '#{name}' has been created successfuly"
          report "#{remote.files.size} files has been detected"
        end
      end

      def create_repo_dir repo
        FileUtils.mkdir_p(File.join(
          Zadar.current_project.path,
          'iso',
          repo.local_path))
      end
    end
  end
end
