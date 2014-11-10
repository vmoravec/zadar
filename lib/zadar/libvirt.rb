require 'nokogiri'

module Zadar
  module Libvirt
    URI = 'qemu:///system'

    def self.connect uri=URI
       const_set(:Connection, ::Libvirt.open(uri))
    end
  end
end

require 'zadar/libvirt/template'
require 'zadar/libvirt/storage_pool'
