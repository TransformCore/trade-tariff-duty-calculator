module Wizard
  module Steps
    class CustomsValue < Wizard::Steps::Base
      include CommodityHelper

      STEPS_TO_REMOVE_FROM_SESSION = %w[additional_code].freeze

      attribute :monetary_value, :string
      attribute :shipping_cost, :string
      attribute :insurance_cost, :string

      validates :monetary_value, presence: true
      validates :monetary_value, numericality: { greater_than: 0 }
      validates :shipping_cost, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
      validates :insurance_cost, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

      def monetary_value
        super || user_session.monetary_value
      end

      def shipping_cost
        super || user_session.shipping_cost
      end

      def insurance_cost
        super || user_session.insurance_cost
      end

      def save
        user_session.customs_value = {
          'monetary_value' => monetary_value,
          'shipping_cost' => shipping_cost,
          'insurance_cost' => insurance_cost,
        }
      end

      def next_step_path
        return measure_amount_path if filtered_commodity.applicable_measure_units.present?

        user_session.measure_amount = {}

        return additional_codes_path(applicable_additional_codes.keys.first) if applicable_additional_codes.present?

        confirm_path
      end

      def previous_step_path
        return previous_step_for_gb_to_ni if user_session.gb_to_ni_route?
        return country_of_origin_path if user_session.row_to_gb_route?

        previous_step_for_row_to_ni
      end

      private

      def previous_step_for_gb_to_ni
        return trade_remedies_path if user_session.trade_defence

        certificate_of_origin_path
      end

      def previous_step_for_row_to_ni
        return country_of_origin_path if user_session.zero_mfn_duty
      end
    end
  end
end
