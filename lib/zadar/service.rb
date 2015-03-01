module Zadar
  class ServiceFailure < StandardError
    attr_reader :service

    def initialize service, message
      @service = service
      super(message)
    end
  end

  class Service
    attr_accessor :failed

    def failed?
      failed.nil? ? false : true
    end

    def succeeded?
      !failed?
    end

    def report message
      messages << message
    end

    def failure! message
      messages << message
      raise ServiceFailure.new(self, message)
    end

    def messages
      @messages ||= []
    end

    def call other_service=nil
      return other_service.call if other_service
      yield
      return self
    rescue => error
      messages << error.message unless error.is_a?(ServiceFailure)
      self.failed = true
      raise error
    end
  end
end
