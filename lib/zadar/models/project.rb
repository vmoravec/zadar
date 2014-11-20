module Zadar
  module Models
    class Project < ActiveRecord::Base
      belongs_to :user
    end
  end
end
