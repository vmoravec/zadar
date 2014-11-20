module Zadar
  module Models
    class User < ActiveRecord::Base
      has_one :project
    end
  end
end
