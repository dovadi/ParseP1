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
  end

end
