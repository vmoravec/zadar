require 'zadar/services/create_new_project'

zadar do
  desc "Create new zadar project"
  command :create do |create|
    create.flag [:n, :name]
    create.action do |_, options, _|
      results << Zadar::Services::CreateNewProject.new(options).call
    end
  end
end
