module Zadar
  module Utils
    class LocalUser
      extend Forwardable

      def_delegators :@info, :uid, :gid

      attr_reader :login, :name

      def initialize
        @login = Etc.getlogin
        @info  = Etc.getpwnam(login)
        @name  = @info.gecos.split(/,/).first
      end

      def to_hash
        { name: name, login: login, uid: uid, gid: gid }
      end
    end
  end
end
