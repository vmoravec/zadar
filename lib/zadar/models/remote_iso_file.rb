module Zadar
  module Models
    class RemoteIsoFile < Sequel::Model
      many_to_one :remote_iso_repo

      alias_method :repo, :remote_iso_repo

      def validate
        errors.add(:url, 'is missing')    if url.nil? || url.to_s.empty?
        errors.add(:mirror, 'is missing') if mirror.nil? || url.to_s.empty?
        errors.add(:filename, 'is missing') if filename.nil? || filename.to_s.empty?
        errors.add(:filename, 'already exists for this repository') if repo.files.find {|f| f.filename == filename }
        errors.add(:size, 'is missing') if size.nil?
        errors.add(:size, 'must be a number') unless size.is_a?(Integer)
        errors.add(:size, 'has zero bytes length') if size.zero?
        errors.add(:mtime, 'must be date/time') unless mtime.is_a?(DateTime)
      end
    end
  end
end

