module Zadar
  module Models
    class LocalIsoRepo < Sequel::Model
      one_to_many :local_iso_files

      URI_SCHEME = "file://"

      alias_method :files, :local_iso_files

      def before_destroy
        remove_all_local_iso_files
      end

      def uri
        URI_SCHEME + path
      end

      def validate
        super
        errors.add(:path, "is invalid")     if invalid_path?
        errors.add(:path, "already exists") if LocalIsoRepo.find(path: path)
        errors.add(:name, "already exists") if LocalIsoRepo.find(name: name)
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
