module Api
  class MeasureCondition < Api::Base
    attributes :action,
               :action_code,
               :condition,
               :condition_code,
               :condition_duty_amount,
               :condition_measurement_unit_code,
               :condition_measurement_unit_qualifier_code,
               :condition_monetary_unit_code,
               :document_code,
               :duty_expression,
               :measure_condition_components,
               :monetary_unit_abbreviation,
               :requirement

    def expresses_unit?
      (condition_measurement_unit_code || condition_monetary_unit_code).present?
    end
  end
end
