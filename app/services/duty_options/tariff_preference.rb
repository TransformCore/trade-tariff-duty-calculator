module DutyOptions
  class TariffPreference < DutyOptions::Base
    PRIORITY = 2
    CATEGORY = :tariff_preference

    def option
      super().merge(
        geographical_area_description: measure.geographical_area.description,
      )
    end
  end
end
