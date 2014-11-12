require 'zadar/services/find_project_volumes'

zadar do
  desc "List all volumes in a project"
  command :volumes do |volumes|
    volumes.flag [:p, :project]
    volumes.action do |_, options, _|
      results << Zadar::Services::FindProjectVolumes.new(options).call
    end
  end
end
