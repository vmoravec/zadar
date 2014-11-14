require 'zadar/services/find_project_volumes'

zadar do
  desc "List all volumes in a project"
  command :volumes do |volumes|
    volumes.action do
      results << Zadar::Services::FindProjectVolumes.new.call
    end
  end
end
