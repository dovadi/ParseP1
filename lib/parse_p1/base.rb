# encoding: UTF-8

module ParseP1

  class Base

    include ParseP1::Electricity
    include ParseP1::Gas

    attr_reader :data, :device_id, :obis_records

    def initialize(data)
      @data = data
      @obis_records = {}
      process(data)
    end

    def valid?
      electra_meter_id.is_a?(String) && actual_electra.is_a?(Float) && gas_meter_id.is_a?(String) && gas_usage.is_a?(Float)
    end

    private

    def process(data)
      processed_data = data.split('/').last.split('!').first.split
      @device_id = processed_data.shift
      extract_obis_records(processed_data)
    end

    def extract_obis_records(data)
      data.each do |item|
        array = item.split('(')
        values = []
        if array[0].match(obis_pattern)
          key = $1
        else
          key = @obis_records.keys.last
          values = @obis_records[key]
        end
        array[1..-1].each do |value|
          value.chop! if value[-1] == ')'
          values << value
        end
        @obis_records[key] = values
      end
    end

    def obis_pattern
      /(\d+-\d+:\d+\.\d+.\d+)/
    end
  end

end
