require 'etc'

module Zadar
  class Seeds
    def self.seed_new_project options
      NewProjectSeed.new(options)
    end
  end

  class NewProjectSeed
    attr_reader :project_name, :path

    def initialize options={}
      @project_name = options[:name]
      @path = options[:path]
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
      Models::Project.create(name: project_name, user: user, path: path)
    end
  end
end
