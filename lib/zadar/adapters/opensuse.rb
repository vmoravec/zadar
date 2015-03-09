module Zadar
  module Adapters
    class Opensuse
      attr_reader :connection, :files, :page, :url

      def initialize url
        @url = url
        @connection = Faraday.new(url) {|r| r.adapter Faraday.default_adapter }
        @files = resolve_refs
      end

      def validate!
      end

      private

      def refs
        @page = Nokogiri::HTML(connection.get.body)
        page.xpath("//a[contains(@href, '.iso')]").grep( /.iso$/).map(&:text)
      end

      def resolve_refs
        refs.map do |ref|
          response = connection.head(ref)
          location = response.headers['location']
          mirror = connection.head(location).headers
          RemoteIsoStruct.new(
            url + ref,
            location,
            filename = Pathname.new(location).basename.to_s,
            mirror['content-length'].to_i,
            DateTime.parse(mirror['last-modified']),
            find_md5(filename),
            find_sha1(filename),
            find_sha256(filename)
          )
        end
      end

      def find_md5 filename
        md5_content = connection.get(
          page.xpath("//a[contains(@href, '#{filename}.md5')]")
          .grep(/.iso.md5$/).first.text)
          .body
        return unless md5_content.match(filename)

        md5_content.split.first
      end

      def find_sha1 filename
        sha1_content = connection.get(
          page.xpath("//a[contains(@href, '#{filename}.sha1')]")
          .grep(/.iso.sha1$/).first.text)
          .body
        return unless sha1_content.match(filename)

        sha1_content.split.first
      end

      def find_sha256 filename
        sha256_element = page.xpath("//a[contains(@href, '#{filename}.sha256')]")
          .grep(/.iso.sha256$/)
          .first
        return unless sha256_element

        sha256_content = connection.get(sha256_element.text).body
        return unless sha256_content
        return unless sha256_content.match(filename)

        sha256_content.split.first
      end
    end
  end
end
