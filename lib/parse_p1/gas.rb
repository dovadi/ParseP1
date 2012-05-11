module ParseP1

  module Gas

    def gas_meter_id
      data.match(/1:96.1.0\S(\d{1,96})\S/)
      $1
    end

    #Only 2 digits for year!
    def last_hourly_reading_gas
      data.match(/0-1:24.3.0\S(\d{12})\S/)
      DateTime.new(('20'+$1[0..1]).to_i, $1[2..3].to_i, $1[4..5].to_i, $1[6..7].to_i, $1[8..9].to_i)
    end

    def measurement_unit_gas
      data.match(/\S0-1:24.2.1\S\S(\w+)\S/)
      $1
    end

    def gas_usage
      data.match(/\S0-1:24.2.1\S\S\w+\S\r\n\S(\d+.\d+)\S/)
      $1.to_f
    end

  end

end