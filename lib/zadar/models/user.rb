module Zadar
  module Models
    class User < Sequel::Model
      one_to_many :project
    end
  end
end
