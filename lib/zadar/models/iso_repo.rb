module Zadar
  module Models
    class IsoRepo < Sequel::Model
      one_to_many :iso_local_files

      URI_SCHEME = "file://"

      alias_method :files, :iso_local_files

      def before_destroy
        remove_all_iso_local_files
      end

      def uri
        URI_SCHEME + path
      end

      def validate
        super
        errors.add(:path, "is invalid")     if invalid_path?
        errors.add(:path, "already exists") if IsoRepo.find(path: path)
        errors.add(:name, "already exists") if IsoRepo.find(name: name)
        errors.add(:name, "is missing")     if name.nil? || name.length.zero?
      end

      private

      def invalid_path?
        URI.parse(URI_SCHEME + path)
        false
      rescue => e
        return true
      end
    end
  end
end
