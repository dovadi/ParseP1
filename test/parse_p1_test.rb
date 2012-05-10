require 'helper'

class TestParseP1 < Test::Unit::TestCase

  def setup
    @p1_string = "\r\n/ABc1\\1AB123-4567\r\n\r\n0-0:96.1.1(1A123456789012345678901234567890)\r\n1-0:1.8.1(00136.787*kWh)\r\n1-0:1.8.2(00131.849*kWh)\r\n1-0:2.8.1(00000.000*kWh)\r\n1-0:2.8.2(00000.000*kWh)\r\n0-0:96.14.0(0002)\r\n1-0:1.7.0(0003.20*kW)\r\n1-0:2.7.0(0000.00*kW)\r\n0-0:17.0.0(0999.00*kW)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-1:24.1.0(3)\r\n0-1:96.1.0(1234567890123456789012345678901234)\r\n0-1:24.3.0(120502150000)(00)(60)(1)(0-1:24.2.1)(m3)\r\n(00092.112)\r\n0-1:24.4.0(1)\r\n!\r\n"
    @parse_p1  = ParseP1::Base.new(@p1_string)
  end

  should 'be valid' do
    assert ParseP1
  end

  should 'return the p1_string' do
    assert_equal @p1_string, @parse_p1.p1_string
  end

  should 'return the device_id of the meter' do
     assert_equal 'ABc1\1AB123-4567', @parse_p1.device_id
  end
end