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

        set_ctime
        set_mtime
        set_size
        set_name
      end

      def validate
        super
        errors.add(:ctime, "is missing")    unless ctime
        errors.add(:mtime, "is missing")    unless mtime
        errors.add(:filename, "is missing") if filename.nil? || filename.length.zero?
        errors.add(:iso_repo, "is missing") unless iso_repo

        if new? && repo && repo.iso_local_files_dataset.where(filename: filename).first
          errors.add(:filename, "already exists")
        end

        if filename && !filename.end_with?(EXT)
          errors.add(:filename, "wrong extension, only #{EXT} allowed")
        end

        if repo && filename
          if !File.exist?(File.join(repo.path, filename.to_s))
            errors.add(:filename, "points to non-existing file")
          end
        end
      end

      private

      def set_ctime
        return if ctime

        self.ctime = load_file.ctime.to_i
      end

      def set_mtime
        return if mtime

        self.mtime = load_file.mtime.to_i
      end


      def set_size
        return if size

        self.size = load_file.size
      end

      def set_name
        file = Pathname.new(filename)
        self.name = file.to_s.split(/#{file.extname}$/).first
      end

      def load_file
        @loaded_file ||= File.new(full_path, 'r')
      end
    end
  end
end
