# encoding: UTF-8

require 'helper'

class TestParseP1LandisGyrE350 < Test::Unit::TestCase

  setup do
    @data = "/ABA5LGAAGGB231007559\n\n1-3:0.2.8(40)\n0-0:1.0.0(150407214315S)\n0-0:96.1.1(4190303034303031356660323031353135)\n1-0:1.8.1(002622.819*kWh)\n1-0:2.8.1(000079.439*kWh)\n1-0:1.8.2(001693.579*kWh)\n1-0:2.8.2(000215.374*kWh)\n0-0:96.14.0(0002)\n1-0:1.7.0(00.524*kW)\n1-0:2.7.0(01.230*kW)\n0-0:17.0.0(999.9*kW)\n0-0:96.3.10(1)\n0-0:96.7.21(00003)\n0-0:96.7.9(00001)\n1-0:99.97.0(1)(0-0:96.7.19)(150327114234W)(0000007487*s)\n1-0:32.32.0(00000)\n1-0:32.36.0(00000)\n0-0:96.13.1()\n0-0:96.13.0()\n1-0:31.7.0(002*A)\n1-0:21.7.0(00.524*kW)\n1-0:22.7.0(00.000*kW)\n0-1:24.1.0(003)\n0-1:96.1.0(4736303136353631323035999235153337)\n0-1:24.2.1(150407210000S)(02638.655*m3)\n0-1:24.4.0(1)\n!"
    @p1   = ParseP1::Base.new(@data)
  end

  context 'Device identifiers' do

     should 'return the device_id of the meter' do
        assert_equal 'ABA5LGAAGGB231007559', @p1.device_id
     end

     should 'return the electra meter identifier of the meter' do
       assert_equal '4190303034303031356660323031353135', @p1.electra_meter_id
     end

    should 'return the gas meter identifier of the meter' do
      assert_equal '4736303136353631323035999235153337', @p1.gas_meter_id
    end

   end

   context 'Electricity data' do

     #S4 tag 4 bit string is NOT true
     should 'return the electricity tariff indicator' do
       assert_equal 2, @p1.electricity_tariff_indicator
     end

     #F4(1,1)
     should 'return the electricity actual threshold' do
       assert_equal 999.9, @p1.electricity_actual_threshold
     end

     #F9 (3,3)
     should 'return imported electricty with low tarif' do
       assert_equal 2622.819, @p1.electricity(:type => :import, :tariff => :low)
       assert_equal 2622.819, @p1.electra_import_low
     end

     #F9 (3,3)
     should 'return imported electricty with normal tarif' do
       assert_equal 1693.579, @p1.electricity(:type => :import, :tariff => :normal)
       assert_equal 1693.579, @p1.electra_import_normal
     end

     #F9 (3,3)
     should 'return electricty produced by client low tarif' do
       assert_equal 79.439, @p1.electricity(:type => :export, :tariff => :low)
       assert_equal 79.439, @p1.electra_export_low
     end

     #F9 (3,3)
     should 'return electricty produced by client normal tarif' do
       assert_equal 215.374, @p1.electricity(:type => :export, :tariff => :normal)
       assert_equal 215.374, @p1.electra_export_normal
     end

     context 'Actual data' do

       #F5 (3,3)
       should 'return actual power imported' do
         assert_equal 524, @p1.electricity(:type => :import, :actual => true)
         assert_equal 524, @p1.actual_electra
         assert_equal 524, @p1.electra_import_actual
       end

       #F5 (3,3)
       should 'return actual power in case of a low tarif' do
         assert_equal 1230, @p1.electricity(:type => :export, :actual => true)
         assert_equal 1230, @p1.electra_export_actual
       end

     end

   end

   context 'Gas data' do

     should 'return the last hourly reading of gas usage' do
       assert_equal DateTime.new(2015,4,7,21,0), @p1.last_hourly_reading_gas
     end

     should 'return the measurement unit of gas usage' do
       assert_equal 'm3', @p1.measurement_unit_gas
     end

     should 'return the total usage of gas' do
       assert_equal 2638.655, @p1.gas_usage
     end

   end

end
