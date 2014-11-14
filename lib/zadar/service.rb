module Zadar
  class ServiceFailure < StandardError
    attr_reader :service

    def initialize service, message
      @service = service
      super(message)
    end
  end

  class UnexpectedFailure < StandardError
  end

  class Service
    attr_accessor :failed

    def failed?
      failed.nil? ? false : failed
    end

    def succeeded?
      !failed?
    end

    def report message
      messages << message
    end

    def failure! message
      self.failed = true
      raise ServiceFailure.new(self, message)
    end

    def messages
      @messages ||= []
    end

    def errors
      @errors ||= []
    end

    def tasks
      @tasks ||= Tasks.new(self)
    end

    alias_method :services, :tasks

    def call
      yield
    rescue ServiceFailure => e
      errors << e.message
    rescue => e
      self.failed = true
      errors << "Service #{self.class.name} failed unexpectedly"
      errors << e.message
      errors << e.backtrace
    ensure
      return self
    end

    class Tasks
      def initialize parent
        @parent = parent
        @tasks = []
      end

      def push task
        @parent.failed = true if task.failed?
        @tasks << task
      end

      def all
        @tasks
      end
    end
  end
end
