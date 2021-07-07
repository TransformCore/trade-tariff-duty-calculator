module DutyOptions
  module AdditionalDuty
    class Base < DutyOptions::Base
      CATEGORY = :additional_duty

      def option_values
        [duty_calculation_row]
      end

      def localised_footnote
        nil
      end
    end
  end
end
