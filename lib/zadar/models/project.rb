module Zadar
  module Models
    class Project < Sequel::Model
      many_to_one :user
    end
  end
end
