require 'etc'

module Zadar
  class Seeds
    def self.seed_new_project options
      new(options)
    end

    attr_reader :project_name

    def initialize options={}
      @project_name = options[:name]
    end

    def seed!
      user = create_admin
      create_project(user)
    end

    private

    def create_admin
      Models::User.create(Zadar.local_user.to_hash.merge(admin: true))
    end

    def create_project user
      # Project.create(name: project_name, user: user)
    end
  end
end
