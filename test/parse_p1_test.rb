# encoding: UTF-8

require 'helper'

class TestParseP1 < Test::Unit::TestCase

  setup do
    #Data string as received on a Ruby on Rails application with some uncleared data in front of it
    @data  = "sBs\u0012C\u0002\u0002\nK*r\"CKR[Wh)\r\n1-0:2.8.1(00000.000*kWh)\r\n1-0:2.8.2(00000.\r\n/ABc1\\1AB123-4567\r\n\r\n0-0:96.1.1(1A123456789012345678901234567890)\r\n1-0:1.8.1(00136.787*kWh)\r\n1-0:1.8.2(00131.849*kWh)\r\n1-0:2.8.1(00002.345*kWh)\r\n1-0:2.8.2(00054.976*kWh)\r\n0-0:96.14.0(0002)\r\n1-0:1.7.0(0003.20*kW)\r\n1-0:2.7.0(0000.12*kW)\r\n0-0:17.0.0(0999.00*kW)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-1:24.1.0(3)\r\n0-1:96.1.0(1234567890123456789012345678901234)\r\n0-1:24.3.0(120502150000)(00)(60)(1)(0-1:24.2.1)(m3)\r\n(00092.112)\r\n0-1:24.4.0(1)\r\n!"
    # @data = "//ISk5\\2MT382-1003\r\n\r\n0-0:96.1.1(5A424556303035303735343938383131)\r\n1-0:1.8.1(01472.740*kWh)\r\n1-0:1.8.2(01664.635*kWh)\r\n1-0:2.8.1(00000.000*kWh)\r\n1-0:2.8.2(00000.001*kWh)\r\n0-0:96.14.0(0001)\r\n1-0:1.7.0(0000.51*kW)\r\n1-0:2.7.0(0000.00*kW)\r\n0-0:17.0.0(0999.00*kW)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-2:24.1.0(3)\r\n0-2:96.1.0(3338303034303031323138333338363132)\r\n0-2:24.3.0(130615120000)(00)(60)(1)(0-2:24.2.1)(m3)\r\n(02910.805)\r\n0-2:24.4.0(1)\r\n!"
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
    should 'return imported electricty with low tarif' do
      assert_equal 136.787, @p1.electricity(:type => :import, :tariff => :low)
      assert_equal 136.787, @p1.electra_import_low
    end

    #F9 (3,3)
    should 'return imported electricty with normal tarif' do
      assert_equal 131.849, @p1.electricity(:type => :import, :tariff => :normal)
      assert_equal 131.849, @p1.electra_import_normal
    end

    #F9 (3,3)
    should 'return electricty produced by client low tarif' do
      assert_equal 2.345, @p1.electricity(:type => :export, :tariff => :low)
      assert_equal 2.345, @p1.electra_export_low
    end

    #F9 (3,3)
    should 'return electricty produced by client normal tarif' do
      assert_equal 54.976, @p1.electricity(:type => :export, :tariff => :normal)
      assert_equal 54.976, @p1.electra_export_normal
    end

    context 'Actual data' do

      #F5 (3,3)
      should 'return actual power imported' do
        assert_equal 3200, @p1.electricity(:type => :import, :actual => true)
        assert_equal 3200, @p1.actual_electra
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

  context 'Gas data send through RF (different OBIS codes)' do

    setup do
      #Different OBIS codes for RF gas measurement:
      # => 0-2:24.1.0
      # => 0-2:96.1.0
      # => 0-2:24.3.0
      # => 0-2:24.2.1
      # => 0-2:24.4.0
      data  = "sBs\u0012C\u0002\u0002\nK*r\"CKR[Wh)\r\n1-0:2.8.1(00000.000*kWh)\r\n1-0:2.8.2(00000.\r\n/ABc1\\1AB123-4567\r\n\r\n0-0:96.1.1(1A123456789012345678901234567890)\r\n1-0:1.8.1(00136.787*kWh)\r\n1-0:1.8.2(00131.849*kWh)\r\n1-0:2.8.1(00002.345*kWh)\r\n1-0:2.8.2(00054.976*kWh)\r\n0-0:96.14.0(0002)\r\n1-0:1.7.0(0003.20*kW)\r\n1-0:2.7.0(0000.12*kW)\r\n0-0:17.0.0(0999.00*kW)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-2:24.1.0(3)\r\n0-2:96.1.0(1234567890123456789012345678901234)\r\n0-2:24.3.0(120502150000)(00)(60)(1)(0-2:24.2.1)(m3)\r\n(00092.112)\r\n0-2:24.4.0(1)\r\n!"
      @p2   = ParseP1::Base.new(@data)
    end

    should 'return the last hourly reading of gas usage' do
      assert_equal DateTime.new(2012,5,2,15,0), @p2.last_hourly_reading_gas
    end

    should 'return the measurement unit of gas usage' do
      assert_equal 'm3', @p2.measurement_unit_gas
    end

    should 'return the total usage of gas' do
      assert_equal 92.112, @p2.gas_usage
    end

  end

  context 'Data with irregularities' do

    setup do
      @irregular_data = [
               "//ABc1\u0001AB123-4567\n0-0:96.1.1(1A123456789012345678901234567890)\n1-0:1.8.1(02145.375*kWh)\n1-0:1.8.2(02043.840*kWh)\n1-0:2.8.1(00000.000*kWh)\n1-0:2.8.2(00000.001*kWh)\n0-0:96.14.0(0001)\n1-0:1.7.0(0000.82*kW)\n1-0:2.7.0(0000.00*kW)\n0-0:17.0.0(0999.00*kW)\n0-0:96.3.10(1)\n0-0:96.13.1()\n0-0:96.13.0()\n0-1:24.1.0(3)\n0-1:96.1.0(3338303034303031313338323831383131)\n0-1:24.3.0(130406220000)(00)(60)(1)(0-1:24.2.1)(m3)\n(01878.044)\n0-1:24.4.0(1)\n!",
               "//ABc1\\1AB123-4567\n0-0:96.1.1(1A123456789012345678901234567890)\n1-0:1.8.1(02145.452*kWh)\n1-0:1.8.2(02043.840*kWh)\n1-0:2.8.1(00000.000*kWh)\n1-0:2.8.2(00000.001*kWh)\n0-0:96.14.0(0001)\n1-0:1.7.0(0000.80*kW)\n1-0:2.7.0(0000.00*kW)\n0-0:17.0.0(0999.00*kW)\n0-0:96.3.10(1)\n0-0:96.13.1()\n0-0:96.13.0()\n0-1:24.1.0(3)\n0-1:96.1.0(3338303034303031313338323831383131)\n0-1:24.3.0(130406220000)(00)(60)(1)(0-1:24.2.1)(m3)\n(01878.044)\n0-1:24.4.0(1)\n!" ,
               "emonweb.org/api HTTP/1.0\r\nHost: emonweb.org\r\nUser-A/ABc1\\1AB123-4567\r\n\r\n0-0:96.1.1(1A123456789012345678901234567890)\r\n1-0:1.8.1(02167.834*kWh)\r\n1-0:1.8.2(02068.811*kWh)\r\n1-0:2.8.1(00000.000*kWh)\r\n1-0:2.8.2(00000.001*kWh)\r\n0-0:96.14.0(0002)\r\n1-0:1.7.0(0000.26*kW)\r\n1-0:2.7.0(0000.00*kW)\r\n0-0:17.0.0(0999.00*kW)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-1:24.1.0(3)\r\n0-1:96.1.0(1234567890123456789012345678901234)\r\n0-1:24.3.0(130411070000)(00)(60)(1)(0-1:24.2.1)(m3)\r\n(01904.959)\r\n0-1:24.4.0(1)\r\n!agent"
              ]
    end

    should 'tell if a very meshed string is P1 valid' do
      @irregular_data.each do |record|
        p1   = ParseP1::Base.new(record)
        assert_equal true, p1.valid?
        assert p1.gas_usage.is_a?(Float)
        assert p1.actual_electra.is_a?(Integer)
        assert p1.device_id.is_a?(String)
        assert p1.electra_meter_id.is_a?(String)
        assert p1.gas_meter_id.is_a?(String)
        assert p1.electra_import_low.is_a?(Float)
        assert p1.electra_import_normal.is_a?(Float)
        assert p1.electra_export_low.is_a?(Float)
        assert p1.electra_export_normal.is_a?(Float)
      end
    end

  end

end