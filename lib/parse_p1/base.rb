# encoding: UTF-8

module ParseP1

  class Base

    include ParseP1::Electricity
    include ParseP1::Gas

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def valid?
      !data.match(/!/).nil? && !device_id.nil?
    end

    def device_id
      match_within_one_p1_record('\/([a-zA-Z]{3}\d{1}.+[a-zA-Z]{2}\d{3}-\d{4}|[a-zA-Z]{3}\d{1}[a-zA-Z]{7}\d{9})')
    end

    private

    def match_within_one_p1_record(pattern)
      data.match(/[\W|\w]*#{pattern}[\W|\w]*!/)
      $1
    end

  end

end