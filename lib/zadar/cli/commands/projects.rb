require 'zadar/services/list_projects'

zadar do
  desc "List zadar libvirt projects"
  command :projects do |projects|
    projects.action do
      results << Zadar::Services::ListProjects.new.call
    end
  end
end
