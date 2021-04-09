module DutyOptions
  module AdditionalDuty
    class Base < DutyOptions::Base
      def option
        super.merge(value: duty_evaluation[:value])
      end

      def option_values
        [duty_calculation_row]
      end
    end
  end
end
