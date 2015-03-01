require 'zadar/services/create_new_project'

zadar do
  desc "Create new zadar project"
  command :create do |create|
    # create.flag [:n, :name], default_value: 'zadar'
    create.action do |_, options, _|
      execute { Zadar::Services::CreateNewProject.new(options) }
    end
  end
end
