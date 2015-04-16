# encoding: UTF-8

module ParseP1

  class Base

    include ParseP1::Electricity
    include ParseP1::Gas

    attr_reader :data, :device_id, :obis_records

    def initialize(data)
      @data = data.split('/').last.split('!').first.split
      @obis_records = {}
      extract_obis_records(@data)
    end

    def valid?
      electra_meter_id.is_a?(String) && actual_electra.is_a?(Float) && gas_meter_id.is_a?(String) && gas_usage.is_a?(Float)
    end

    def device_id
      data.shift
    end

    private

    def extract_obis_records(data)
      data.each do |item|
        obis_values     = item.split('(')
        previous_values = []

        key = extract_key(obis_values)

        #Values without a key are associated with the last known key
        if key.nil?
          key = @obis_records.keys.last
          previous_values = @obis_records[key] if key
        end

        @obis_records[key] = previous_values + cleanup(obis_values)
      end
    end

    def extract_key(record)
      record.first.match(obis_record_pattern)
      $1
    end

    def cleanup(obis_values)
      obis_values[1..-1].map {|value| value[-1] == ')' ? value.chop : value }
    end

    def obis_record_pattern
      /(\d+-\d+:\d+\.\d+.\d+)/
    end
  end

end
