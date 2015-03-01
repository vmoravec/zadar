require 'zadar/services/start_console'

main = self

zadar do
  desc "Start irb console with zadar environment"
  command :console do |console|
    console.flag [:e, :env]
    console.action do |_, options, _|
      call { Zadar::Services::StartConsole.new(options.merge(main: main)) }
    end
  end
end
