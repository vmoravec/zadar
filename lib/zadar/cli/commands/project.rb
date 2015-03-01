require 'zadar/services/list_projects'

zadar do
  desc "List zadar libvirt projects"
  command :project do |project|
    project.action do
      call { Zadar::Services::ListProjects.new }
    end
  end
end
