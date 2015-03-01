module Zadar
  module Models
    class IsoLocalFile < Sequel::Model
      EXT = ".iso"

      many_to_one :iso_repo

      alias_method :repo, :iso_repo

      def full_path
        return unless repo

        File.join(repo.path, filename)
      end

      def before_validation
        return unless filename
        return if name

        file = Pathname.new(filename)
        self.name = file.to_s.split(/#{file.extname}$/).first
      end

      def validate
        super
        errors.add(:filename, "is missing") if filename.nil? || filename.length.zero?

        if filename && !filename.end_with?(EXT)
          errors.add(:filename, "wrong extension, only #{EXT} allowed")
        end

        if repo && filename
          if !File.exist?(File.join(repo.path, filename.to_s))
            errors.add(:filename, "points to non-existing file")
          end
        end
      end
    end
  end
end
