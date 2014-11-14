require 'gli'

module Zadar
  module Cli
    class Command
      include ::GLI::App

      COMMANDS_DIR = 'commands'

      attr_reader :load_path
      attr_reader :argv
      attr_accessor :name
      attr_accessor :exit_code
      attr_reader :results
      attr_reader :errors

      def initialize argv
        @results = []
        @errors  = []
        @exit_code = 0
        @argv = argv
        @load_path = Pathname.new(__dir__).join(COMMANDS_DIR)
        detect_command_name
        configure_gli
        manage_errors
      end

      def dsl &block
        instance_eval &block
        run
        exit
      end

      def load
        case name
        when nil, '', 'help'
          load_help
        else
          load_command_file
        end
      end

      def run
        catch(:failure) do
          super(argv)
        end

        failed = results.find(&:failed?)
        self.exit_code = 1 if failed || !errors.empty?

        error_messages = results.select(&:failed?).map(&:errors)
        errors.concat(error_messages)

        messages = results.map(&:messages).flatten

        STDOUT.puts(messages.join("\n")) unless messages.empty?
        STDERR.puts(errors.join("\n")) unless errors.empty?

      rescue => e
        display_error(e)
      end

      private

      def detect_command_name
        self.name = argv.first.to_s.start_with?('--') || argv.first.to_s.start_with?('-') ? nil : argv.first
      end

      def load_help
      end

      def load_command_file
        file = load_path.join("#{name}.rb")
        detect_command_file(file)
        require file
      end

      def detect_command_file file
        unless File.exists?(file)
          puts "Zadar does not know command '#{name}'"
          puts "Try 'zadar help'"
          exit 1
        end
      end

      def configure_gli
        program_desc "Virtualization management and sharing system"
        version      ::Zadar::VERSION
        flag [:p, :project]
      end

      def manage_errors
        on_error do |error|
          display_error(error)
        end
      end

      def exit code=nil
        self.exit_code = code if code
        Kernel.exit(exit_code)
      end

      def failure message
        self.exit_code = 1
        errors << message
        throw :failure
      end

      def display_error error
        case error
        when GLI::UnknownCommandArgument
          puts error.message
        when OptionParser::MissingArgument
          puts "Incomplete command, #{error.message}"
        else
          puts "This is a bug.\n#{error.class}: #{error.message}"
          puts "Backtrace: #{error.backtrace.join "\n"}"
        end
      end

    end
  end
end
