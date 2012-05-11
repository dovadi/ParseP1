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

  end

end