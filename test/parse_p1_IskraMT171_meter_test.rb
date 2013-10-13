# encoding: UTF-8

require 'helper'

class TestParseP1_IskraMT171Meter < Test::Unit::TestCase

  setup do
    @data = "/XMX5XMXABCE100085870\r\n\r\n0-0:96.1.1(31333836343734322020202020202020)\r\n1-0:1.8.1(00477.462*kWh)\r\n1-0:1.8.2(00546.069*kWh)\r\n1-0:2.8.1(00013.172*kWh)\r\n1-0:2.8.2(00031.349*kWh)\r\n0-0:96.14.0(0001)\r\n1-0:1.7.0(0000.23*kW)\r\n1-0:2.7.0(0000.00*kW)\r\n0-0:17.0.0(999*A)\r\n0-0:96.3.10(1)\r\n0-0:96.13.1()\r\n0-0:96.13.0()\r\n0-1:96.1.0(3238303131303038333134303934333133)\r\n0-1:24.1.0(03)\r\n0-1:24.3.0(131013140000)(08)(60)(1)(0-1:24.2.0)(m3)\r\n(00143.136)\r\n0-1:24.4.0(1)\r\n!"

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
       assert_equal 'XMX5XMXABCE100085870', @p1.device_id
    end

    #Sn (n=0..96), octet string is NOT true
    should 'return the electra meter identifier of the meter' do
      assert_equal '31333836343734322020202020202020', @p1.electra_meter_id
    end

    #Sn (n=0..96) octet string 
    should 'return the gas meter identifier of the meter' do
      assert_equal '3238303131303038333134303934333133', @p1.gas_meter_id
    end

  end

  context 'Electricity data' do

    #S4 tag 4 bit string is NOT true
    should 'return the electricity tariff indicator' do
      assert_equal 1, @p1.electricity_tariff_indicator
    end

    #F4(1,1)
    should 'return the electricity actual threshold' do
      assert_equal 999.0, @p1.electricity_actual_threshold
    end

    #F9 (3,3)
    should 'return electricity with a corresponding obis code' do
      assert_equal 477.462, @p1.electricity('1-0:1.8.1')
    end

    #F9 (3,3)
    should 'return imported electricty with low tarif' do
      assert_equal 477.462, @p1.electricity(:type => :import, :tariff => :low)
      assert_equal 477.462, @p1.electra_import_low
    end

    #F9 (3,3)
    should 'return imported electricty with normal tarif' do
      assert_equal 546.069, @p1.electricity(:type => :import, :tariff => :normal)
      assert_equal 546.069, @p1.electra_import_normal
    end

    #F9 (3,3)
    should 'return electricty produced by client low tarif' do
      assert_equal 13.172, @p1.electricity(:type => :export, :tariff => :low)
      assert_equal 13.172, @p1.electra_export_low
    end

    #F9 (3,3)
    should 'return electricty produced by client normal tarif' do
      assert_equal 31.349, @p1.electricity(:type => :export, :tariff => :normal)
      assert_equal 31.349, @p1.electra_export_normal
    end

    context 'Actual data' do

      #F5 (3,3)
      should 'return actual power imported' do
        assert_equal 230, @p1.electricity(:type => :import, :actual => true)
        assert_equal 230, @p1.actual_electra
      end

    end

  end

  context 'Gas data' do

    should 'return the last hourly reading of gas usage' do
      assert_equal DateTime.new(2013,10,13,14,0), @p1.last_hourly_reading_gas
    end

    should 'return the measurement unit of gas usage' do
      assert_equal 'm3', @p1.measurement_unit_gas
    end

    should 'return the total usage of gas' do
      assert_equal 143.136, @p1.gas_usage
    end

  end

end