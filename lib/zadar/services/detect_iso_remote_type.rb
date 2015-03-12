module Zadar
  module Services
    class DetectIsoRemoteType < Service
      SUPPORTED_PROTOCOLS = %w( http https )
      DEFAULT_TYPES = {
        opensuse: /download.opensuse.org/
      }

      attr_reader :url, :type, :uri

      def initialize options
        @url = options[:url]
      end

      def call
        super do
          @type = detect_remote_type
          report "Detected remote iso repo of type '#{type}'"
        end
      end

      private

      def detect!
        type = DEFAULT_TYPES.find { |type, regex| url.match(regex) }
        failure! "Failed to detect repository type from given url" unless type

        type.first
      end

      def detect_remote_type
        @uri = URI.parse(url)
        validate_url
        detect!
      end

      def validate_url
        failure! "Missing protocol" if uri.nil?
        if !SUPPORTED_PROTOCOLS.include?(uri.scheme)
          failure! "Unsupported protocol: #{uri.scheme}, allowed: #{SUPPORTED_PROTOCOLS.join(", ")}"
        end
        failure! "An absolute url is required" unless uri.absolute?
      end
    end
  end
end
