module Wizard
  module Steps
    class CustomsValue < Base
      STEP_ID = '4'.freeze

      attribute 'monetary_value', :string
      attribute 'shipping_cost', :string
      attribute 'insurance_cost', :string

      validates :monetary_value, presence: true
      validates :monetary_value, numericality: true
      validates :shipping_cost, numericality: true, allow_blank: true
      validates :insurance_cost, numericality: true, allow_blank: true

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

      def next_step_path(service_choice:, commodity_code:)
        # To be added on the ticket that creates the next step
      end

      def previous_step_path(service_choice:, commodity_code:)
        country_of_origin_path(service_choice: service_choice, commodity_code: commodity_code)
      end
    end
  end
end