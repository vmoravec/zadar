module Zadar
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

    def report_error message
      messages << message
      self.failed = true
    end

    def messages
      return @messages if @messages

      @messages = []
    end

    def tasks
      return @tasks if @tasks

      @tasks = []
    end

    def call
      yield
    rescue => e
      report_error(e.message)

      #TODO
      #Implement zadar logger and use it here
    ensure
      return self
    end
  end
end
