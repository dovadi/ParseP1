# encoding: UTF-8

module ParseP1

  module Electricity

    def electra_meter_id
      result = obis_records['0-0:96.1.1']
      result.first if result
    end

    def electricity_tariff_indicator
      get_electricity('0-0:96.14.0')
    end

    def electricity_actual_threshold
      get_electricity('0-0:17.0.0')
    end

    def electra_import_low
      get_electricity('1-0:1.8.2')
    end

    def electra_import_normal
      get_electricity('1-0:1.8.1')
    end

    def electra_export_low
      get_electricity('1-0:2.8.2')
    end

    def electra_export_normal
      get_electricity('1-0:2.8.1')
    end

    #Only for backward compatibility
    def actual_electra
      electra_import_actual
    end

    def electra_import_actual
      get_electricity('1-0:1.7.0') * 1000
    end

    def electra_export_actual
      get_electricity('1-0:2.7.0') * 1000
    end

    def electricity(options)
      message = "electra_#{options[:type].to_s}_"
      if options[:actual] == true
        send(message + 'actual')
      else
        send(message + "#{options[:tariff].to_s}")
      end
    end

    private

    def get_electricity(obis_code)
      result = obis_records[obis_code]
      result ? result.first.to_f : 0.0
    end

  end

end
