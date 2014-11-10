require 'zadar/services/start_console'

zadar do
  desc "Start irb console with zadar environment"
  command :console do |console|
    console.action do
      Zadar::Services::StartConsole.new.call
    end
  end
end
