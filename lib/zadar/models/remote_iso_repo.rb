module Zadar
  module Models
    class RemoteIsoRepo < Sequel::Model
      one_to_many :remote_iso_files

      alias_method :files, :remote_iso_files

      def before_destroy
        remove_all_remote_iso_files
      end

      def validate
        super
        errors.add(:url, "is invalid") if invalid_path?
        errors.add(:url, "already exists")  if RemoteIsoRepo.find(url: url)
        errors.add(:name, "already exists") if RemoteIsoRepo.find(name: name)
        errors.add(:name, "is missing")     if name.nil? || name.length.zero?
      end

      private

      def invalid_path?
        url = URI.parse(url)
        return false unless url.absolute?

        false
      rescue => e
        return true
      end
    end
  end
end
