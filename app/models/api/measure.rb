module Api
  class Measure < Api::Base
    has_many :measure_conditions, MeasureCondition
    has_many :measure_components, MeasureComponent

    has_one :measure_type, MeasureType
    has_one :geographical_area, GeographicalArea
    has_one :duty_expression, DutyExpression
    has_one :order_number, OrderNumber
    has_one :additional_code, AdditionalCode

    meta_attribute :duty_calculator, :source

    attributes :id,
               :additional_code,
               :duty_expression,
               :effective_end_date,
               :effective_start_date,
               :excise,
               :excluded_countries,
               :footnotes,
               :geographical_area,
               :import,
               :legal_acts,
               :measure_type,
               :national_measurement_units,
               :order_number,
               :origin,
               :reduction_indicator,
               :vat

    def document_codes
      measure_conditions.map(&:document_code)
    end

    def evaluator_for(user_session)
      if ad_valorem?
        ExpressionEvaluators::AdValorem.new(self, component, user_session)
      elsif specific_duty?
        ExpressionEvaluators::MeasureUnit.new(self, component, user_session)
      else
        ExpressionEvaluators::Compound.new(self, nil, user_session)
      end
    end

    # Compound components (where there are more than one) need to be evaluated by each individual component and have slightly different logic
    def evaluator_for_compound_component(component, user_session)
      if component.ad_valorem?
        ExpressionEvaluators::AdValorem.new(self, component, user_session)
      elsif component.specific_duty?
        ExpressionEvaluators::MeasureUnit.new(self, component, user_session)
      end
    end

    def component
      @component ||= all_components.first
    end

    def all_components
      # TODO: This needs to include measure condition components
      @all_components ||= measure_components
    end

    def all_duties_zero?
      return false if vat.present?

      all_components.all? { |component| component.duty_amount.zero? }
    end

    def vat_type
      return if vat.blank?
      return 'VAT' if additional_code.attributes.values.all?(&:blank?)

      additional_code.code
    end

    private

    def ad_valorem?
      single_component? &&
        amount_or_percentage? &&
        component.no_specific_duty?
    end

    def specific_duty?
      single_component? &&
        amount_or_percentage? &&
        component.specific_duty?
    end

    def amount_or_percentage?
      component.duty_expression_id == '01'
    end

    def single_component?
      all_components.length == 1
    end
  end
end
