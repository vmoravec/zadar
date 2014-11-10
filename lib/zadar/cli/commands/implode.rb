require 'zadar/services/implode_project'

zadar do
  desc "Wipeout the project"
  command :implode do |implode|
    implode.flag [:n, :name]
    implode.action do |_, options, _|
      Zadar::Services::ImplodeProject.new(options).call
    end
  end
end
