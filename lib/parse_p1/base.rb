module ParseP1

  class Base

    attr_reader :p1_string
    
    def initialize(p1_string)
      @p1_string = p1_string
    end

    def device_id
      p1_string.match(/^\/([a-zA-Z]{3}\d{1}.+)\r$/)
      $1 
    end

    def electra_meter_id
      p1_string.match(/0:96.1.1\S(\d{1}[A-Z]{1}\d{1,96})\S/)
      $1
    end

    def gas_meter_id
      p1_string.match(/1:96.1.0\S(\d{1,96})\S/)
      $1
    end

  end

end