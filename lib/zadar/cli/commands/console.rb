require 'zadar/services/start_console'

zadar do
  desc "Start irb console with zadar environment"
  command :console do |console|
    console.flag [:e, :env]
    console.action do |_, options, _|
      Zadar::Services::StartConsole.new(options).call
    end
  end
end
