module Zadar
  module Models
    class RemoteIsoRepo < Sequel::Model
      one_to_many :remote_iso_files

      alias_method :files, :remote_iso_files

      def before_destroy
        remove_all_remote_iso_files
      end

      def before_validation
        guess_local_dirname unless local_path
      end

      def before_create
        check_local_path_exists
      end

      def before_update
        check_local_path_exists
      end

      def validate
        super
        errors.add(:local_path, "is missing") if local_path.nil? || local_path.to_s.empty?
        errors.add(:url, "is invalid")      if invalid_url?
        errors.add(:url, "already exists")  if RemoteIsoRepo.find(url: url)
        errors.add(:name, "is missing")     if name.nil? || name.length.zero?
        errors.add(:name, "already exists") if RemoteIsoRepo.find(name: name)
      end

      private

      def check_local_path_exists
        errors.add(:local_path, "already exists") if Dir.exist?(local_path)
      end

      def guess_local_dirname
        return if local_path
        self.local_path = name.to_s.downcase.join("-")
      end

      def invalid_url?
        url = URI.parse(url)
        return false unless url.absolute?

        false
      rescue => e
        return true
      end
    end
  end
end
