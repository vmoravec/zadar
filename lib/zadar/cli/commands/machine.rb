require 'zadar/services/find_machines'

zadar do
  desc "List all volumes in a project"
  command :machine do |machine|
    machine.action do
      results << Zadar::Services::FindMachines.new.call
    end
  end
end
