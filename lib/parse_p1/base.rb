module ParseP1

  class Base

    include ParseP1::Electricity
    include ParseP1::Gas

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

  end

end