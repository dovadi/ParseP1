require 'helper'

class TestParseP1 < Test::Unit::TestCase

  def setup
    #Data string as received on a Ruby on Rails application
    @data = "\r\n/ABc1\\1AB123-4567\r\n\r\n0-0:96.1.1(1A123456789012345678901234567890)\r\n1-0:1.8.1(00136.787*kWh)\r\n1-0:1.8.2(00131.849*kWh)\r\n1-0:2.8.1(00002.345*kWh)\r\n1-0:2.8.2(00054.976*kWh)\r\n0-0:96.14.0(0002)\r\n1-0:1.7.0(0003.20*kW)\r\n1-0:2.7.0(0000.12*kW)\r\n0-0:17.0.0(0999.00*kW)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-1:24.1.0(3)\r\n0-1:96.1.0(1234567890123456789012345678901234)\r\n0-1:24.3.0(120502150000)(00)(60)(1)(0-1:24.2.1)(m3)\r\n(00092.112)\r\n0-1:24.4.0(1)\r\n!"
    @p1   = ParseP1::Base.new(@data)
  end

  should 'return the p1_string' do
    assert_equal @data, @p1.data
  end

  should 'tell if string is P1 valid' do
    assert_equal true, @p1.valid?
  end

  context 'Device identifiers' do

    should 'return the device_id of the meter' do
       assert_equal 'ABc1\1AB123-4567', @p1.device_id
    end

    #Sn (n=0..96), octet string is NOT true
    should 'return the electra meter identifier of the meter' do
      assert_equal '1A123456789012345678901234567890', @p1.electra_meter_id
    end

    #Sn (n=0..96) octet string 
    should 'return the gas meter identifier of the meter' do
      assert_equal '1234567890123456789012345678901234', @p1.gas_meter_id
    end

  end

  context 'Electricity data' do

    #S4 tag 4 bit string is NOT true
    should 'return the electricity tariff indicator' do
      assert_equal 2, @p1.electricity_tariff_indicator
    end

    #F4(1,1)
    should 'return the electricity actual threshold' do
      assert_equal 999.0, @p1.electricity_actual_threshold
    end

    #F9 (3,3)
    should 'return electricity with a corresponding obis code' do
      assert_equal 136.787, @p1.electricity('1-0:1.8.1')
    end

    #F9 (3,3)
    should 'return imported electricty with normal tarif' do
      assert_equal 136.787, @p1.electricity(:type => :import, :tariff => :normal)
    end

    #F9 (3,3)
    should 'return imported electricty with low tarif' do
      assert_equal 131.849, @p1.electricity(:type => :import, :tariff => :low)
    end

    #F9 (3,3)
    should 'return electricty produced by client normal tarif' do
      assert_equal 2.345, @p1.electricity(:type => :export, :tariff => :normal)
    end

    #F9 (3,3)
    should 'return electricty produced by client low tarif' do
      assert_equal 54.976, @p1.electricity(:type => :export, :tariff => :low)
    end

    context 'Actual data' do

      #F5 (3,3)
      should 'return actual power imported' do
        assert_equal 3200, @p1.electricity(:type => :import, :actual => true)
      end

      #F5 (3,3)
      should 'return actual power in case of a low tarif' do
        assert_equal 120, @p1.electricity(:type => :export, :actual => true)
      end

    end

  end

  context 'Gas data' do

    should 'return the last hourly reading of gas usage' do
      assert_equal DateTime.new(2012,5,2,15,0), @p1.last_hourly_reading_gas
    end

    should 'return the measurement unit of gas usage' do
      assert_equal 'm3', @p1.measurement_unit_gas
    end

    should 'return the total usage of gas' do
      assert_equal 92.112, @p1.gas_usage
    end

  end

end