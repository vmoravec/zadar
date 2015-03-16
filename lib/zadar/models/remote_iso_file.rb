module Zadar
  module Models
    class RemoteIsoFile < Sequel::Model
      many_to_one :remote_iso_repo

      alias_method :repo, :remote_iso_repo

      def before_create
        puts "Warning: no control hash for iso file" unless md5 || sha1 || sha256
      end

      def after_find
        set_mirror
      end

      def validate
        super
        errors.add(:remote_iso_repo, "is missing") if remote_iso_repo.nil?
        errors.add(:url, 'is missing')    if url.nil? || url.to_s.empty?
        errors.add(:mirror, 'is missing') if mirror.nil? || url.to_s.empty?
        errors.add(:filename, 'is missing') if filename.nil? || filename.to_s.empty?
        #errors.add(:filename, 'already exists for this repository') if repo.files.find {|f| f.filename == filename }
        errors.add(:size, 'is missing') if size.nil?
        errors.add(:size, 'must be a number') unless size.is_a?(Integer)
        errors.add(:size, 'has zero bytes length') if size.zero?
        errors.add(:mtime, 'must have date/time format') unless mtime.is_a?(DateTime) || mtime.is_a?(Time)
      end

      private

      def set_mirror
        puts "Mirror not set. Using url value"
        self.mirror ||= url
      end
    end
  end
end

