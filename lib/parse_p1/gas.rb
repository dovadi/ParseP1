# encoding: UTF-8

module ParseP1

  module Gas

    def gas_meter_id
      match_within_one_p1_record('1:96.1.0\S(\d{1,96})\S')
    end

    #Only 2 digits for year!
    def last_hourly_reading_gas
      result = match_within_one_p1_record('0-1:24.3.0\S(\d{12})\S')
      DateTime.new(('20'+result[0..1]).to_i, result[2..3].to_i, result[4..5].to_i, result[6..7].to_i, result[8..9].to_i) if result
    end

    def measurement_unit_gas
      match_within_one_p1_record('0-1:24.2.1\S\S(\w+)\S')
    end

    def gas_usage
      result = match_within_one_p1_record('\S0-1:24.2.1\S\S\w+\S\r\n\S(\d+.\d+)\S')
      result.to_f if result
    end

  end

end