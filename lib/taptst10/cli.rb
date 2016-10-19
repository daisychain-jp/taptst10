require 'thor'

module Taptst10
  class CLI < Thor
    desc "red WORD", "red words print."
    def save(csv_file_name)
      records = Taptst10::Access.all_records

      File.open(csv_file_name, 'a') do |file|
        records.each_with_index do |watt_data, index|
          field_arr = []
          time = watt_data[:time]

          field_arr << (index + 1).to_s
          field_arr <<
            time.strftime("%Y/%m/%d-%H:%M:%S")
          field_arr << "%.1f" % watt_data[:watt]
          field_arr << "%.2f" % watt_data[:kwh]

          file.write(field_arr.join(",") + "\n")
        end
      end
    end
  end
end
