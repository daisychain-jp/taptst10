require 'libusb'

module Taptst10
  class Usb
    VENDOR_ID = 0x040b
    PRODUCT_ID = 0x2201

    def initialize
      usb = LIBUSB::Context.new
      @device = usb.devices(:idVendor => VENDOR_ID,
                            :idProduct => PRODUCT_ID).first
    end

    def open
      return if @device.nil?

      @device.configurations.each do |config_desc|
        @hdev = @device.open
        config_desc.interfaces.each do |interface|
          interface.alt_settings.each do |if_desc|
            @ep_in = @device.endpoints.find{|ep| ep.direction == :in }
            @ep_out = @device.endpoints.find{|ep| ep.direction == :out }
          end
        end
      end
    end

    def read(data_len, timeout)
      args = {:endpoint => @ep_in,
              :dataIn   => data_len,
              :timeout  => timeout}

      data = @hdev.interrupt_transfer(args)
      if data == nil
        raise IOError
      end

      return data
    rescue => e
      raise e
    end

    def write(data, timeout)
      args = {:endpoint => @ep_out,
              :dataOut  => data,
              :timeout  => timeout}

      num_bytes_written = @hdev.interrupt_transfer(args)
      return num_bytes_written
    rescue => e
      raise e
    end

    def close
      @hdev.close
    end
  end
end
