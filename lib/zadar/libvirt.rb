require 'zadar/libvirt/storage_pool'

module Zadar
  module Libvirt
    URI = 'qemu:///system'

    def self.connect uri=URI
       const_set(:Connection, ::Libvirt.open(uri))
    end
  end
end
