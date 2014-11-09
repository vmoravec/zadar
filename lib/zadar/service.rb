module Zadar
  class Service
    def failure! message
      messages << message
      throw(:failure, {type: :failure, messages: messages})
    end

    def report message
      messages << message
    end

    def messages
      return @messages if @messages

      @messages = []
    end

    def success! message=nil
      messages << message
      throw(:success, {type: :success, messages: messages})
    end

    def call
      yield
      success!
    end
  end
end
