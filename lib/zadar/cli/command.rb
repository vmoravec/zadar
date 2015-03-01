require 'gli'
require 'columnize'

module Zadar
  module Cli
    class CommandFailure < StandardError; end

    class Command
      include ::GLI::App

      COMMANDS_DIR = 'commands'

      attr_reader :load_path
      attr_reader :argv
      attr_accessor :name
      attr_accessor :exit_code
      attr_accessor :result

      def initialize argv
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
        if name != 'help'
          run(argv)
          exit
        end
      end

      def load
        case name
        when nil, '', 'help'
          load_help
        else
          load_command_file
        end
      end

      def failure message
        raise CommandFailure, message
      end

      def execute
        @result = yield
        result.call
        puts result.messages.join ("\n") unless result.messages.empty?
      end

      alias_method :call, :execute

      private

      def manage_errors
        on_error do |error|
          self.exit_code = 1
          case error
            when Zadar::ServiceFailure
              puts error.message
            when CommandFailure
              puts error.message
            when Sequel::ValidationFailed
              puts "Command #{name} failed: #{error.message}"
            else display_error(error)
          end
        end
      end


      def detect_command_name
        self.name = argv.first.to_s.start_with?('--') || argv.first.to_s.start_with?('-') ? nil : argv.first
      end

      def load_help
        self.name = 'help'
        load_path.children.each {|command| require command }
        run(argv)
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
      end

      def exit code=nil
        self.exit_code = code if code
        Kernel.exit(exit_code)
      end

      def display_error error
        case error
        when GLI::UnknownCommandArgument
          puts error.message
        when OptionParser::MissingArgument
          puts "Incomplete command, #{error.message}"
        else
          puts "This is a bug."
          puts "Thanks for reporting this to https://github.com/vmoravec/zadar/issues"
          puts "#{error.class}: #{error.message}"
          puts "Backtrace: #{error.backtrace.join "\n"}"
        end
      end

    end
  end
end
