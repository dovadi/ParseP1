module ParseP1

  module Electricity

    def electra_meter_id
      match_within_one_p1_record('0:96.1.1\S(\d{1}[A-Z]{1}\d{1,96})\S')
    end

    def electricity_tariff_indicator
      result = match_within_one_p1_record('0-0:96.14.0\S(\d{1,9})\S')
      result.to_i if result
    end

    def electricity_actual_threshold
      electricity('0-0:17.0.0')
    end

    def electricity(options)
      if options.is_a?(Hash)
        if options[:actual] == true
          get_actual_electricity(options[:type])
        else
          get_electricity("1-0:#{first_electricity_code(options[:type])}.8.#{second_electricity_code(options[:tariff])}")
        end
      else
        get_electricity(options)
      end
    end

    private

    def get_electricity(obis_code)
      data.match(/\/[\W|\w]*#{obis_code}\S(\d{1,9}\.\d{1,3})\S[\W|\w]*!/)
      $1.to_f if $1
    end

    def get_actual_electricity(type)
      power = get_electricity("1-0:#{first_electricity_code(type)}.7.0")
      (power * 1000).to_i if power#Return as watts instead of kW
    end

    def first_electricity_code(code)
      case code
      when :import; '1'
      when :export; '2'
      end
    end

    def second_electricity_code(tariff)
      case tariff
      when :normal; 1
      when :low; 2
      end
    end

  end

end