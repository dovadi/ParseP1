# encoding: UTF-8

module ParseP1

  module Gas

    def gas_meter_id
      obis_records['0-1:96.1.0'].first
    end

    #Only 2 digits for year!
    def last_hourly_reading_gas
      result = get_gas(0)
      DateTime.new(('20'+result[0..1]).to_i, result[2..3].to_i, result[4..5].to_i, result[6..7].to_i, result[8..9].to_i) if result
    end

    #TODO remove this silly method?
    def measurement_unit_gas
      'm3'
    end

    def gas_usage
      result = get_gas(-1)
      result.to_f if result
    end

    private

    def get_gas(index_of_values)
      gas_obis_codes.each do |obis_code|
        @result = obis_records[obis_code]
        break unless @result.nil?
      end
      @result[index_of_values] if @result
    end

    def gas_obis_codes
      ['0-1:24.3.0', '0-1:24.2.1', '0-2:24.1.0', '0-2:24.3.0', '0-2:24.2.1', '0-2:24.4.0']
    end

  end

end
