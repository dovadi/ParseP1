module ParseP1

  class Base

    attr_reader :data
    
    def initialize(data)
      @data = data
    end

    def valid?
      !data.match(/!\r\n$/).nil? && !device_id.nil?
    end

    def device_id
      data.match(/^\/([a-zA-Z]{3}\d{1}.+)\r$/)
      $1 
    end

    def electra_meter_id
      data.match(/0:96.1.1\S(\d{1}[A-Z]{1}\d{1,96})\S/)
      $1
    end

    def gas_meter_id
      data.match(/1:96.1.0\S(\d{1,96})\S/)
      $1
    end

    def electricity(options)
      if options.is_a?(Hash)
        get_electricity("1-0:#{first_electricity_code(options[:type])}.8.#{second_electricity_code(options[:tariff])}")
      else
        get_electricity(options)
      end
    end

    private

    def get_electricity(obis_code)
      data.match(/#{obis_code}\S(\d{1,9}\.\d{3})\S/)
      $1.to_f
    end

    def first_electricity_code(code)
      case code
      when :import; 1
      when :export; 2
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