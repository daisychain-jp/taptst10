require 'bigdecimal'

module Taptst10
  class Access
    COMMAND_GET_DATA = "02180a"
    RECORD_INTERVAL_SEC = (10 * 60)
    NULL_BYTE = 0xfe
    BLOCK_DATA_LENGTH = 17

    def self.all_records
      timeout_ms = 1000

      usb = Usb.new
      usb.open

      # write get_data command
      num_bytes = usb.write([COMMAND_GET_DATA].pack("H*"),
                            timeout_ms)
      if num_bytes != [COMMAND_GET_DATA].pack("H*").length
        raise "get_data command could not be written"
      end

      # read attribute block data
      attr_data_raw = usb.read(BLOCK_DATA_LENGTH,
                               timeout_ms)
      if attr_data_raw.length != BLOCK_DATA_LENGTH
        raise "Attribute block data could not be read"
      end
      attr_data = attr_data_raw.unpack("C*")
      measure_time_min = attr_data[1]
      measure_time_sec = attr_data[2]
      num_bytes = (attr_data[3] << 8) |
                  (attr_data[4] << 0)
      num_records = num_bytes / 3

      # calculate initial and last time stamps
      last_record_time =
        Time.now -
        ((measure_time_min * 60) + measure_time_sec)
      initial_record_time =
        last_record_time -
        ((num_records - 1) * RECORD_INTERVAL_SEC)

      watt_data_arr = []
      count_records = 0
      while count_records <= num_records do
        # read block data
        block_data_raw = usb.read(BLOCK_DATA_LENGTH,
                                  timeout_ms)
        if block_data_raw.length != BLOCK_DATA_LENGTH
          raise "Block data could not be read"
        end
        block_data = block_data_raw.unpack("C*")

        1.step(15, 3) do |i|
          watt_data = {}

          if block_data[i] == NULL_BYTE
            break
          end
          count_records += 1

          watt_data[:time] =
            initial_record_time +
            ((count_records - 1) * (10 * 60))

          watt = ((block_data[i+0] & 0x7f) << 8) |
                 ((block_data[i+1] & 0xff) << 0)
          if (block_data[i] & 0x80) == 0x80
            watt = watt / 10.0
          end
          watt_data[:watt] = watt

          kwh_unit = block_data[i+2] / 100.0
          if watt_data_arr.length <= 0
            watt_data[:kwh] = BigDecimal(kwh_unit.to_s).floor(2).to_f
          else
            # rationalize float error
            kwh_bigd = BigDecimal(watt_data_arr.last[:kwh].to_s) + BigDecimal(kwh_unit.to_s)
            watt_data[:kwh] = kwh_bigd.to_f
          end

          watt_data_arr << watt_data
        end

        if block_data[BLOCK_DATA_LENGTH - 1] == NULL_BYTE
          break
        end
      end

      usb.close

      return watt_data_arr
    rescue => e
      raise e
    end
  end
end
