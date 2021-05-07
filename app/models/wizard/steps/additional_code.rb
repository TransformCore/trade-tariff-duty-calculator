module Wizard
  module Steps
    class AdditionalCode < Wizard::Steps::Base
      include CommodityHelper

      STEPS_TO_REMOVE_FROM_SESSION = %w[].freeze

      attribute :measure_type_id, :string
      attribute :additional_code, :string

      validates :measure_type_id, presence: true
      validates :additional_code, presence: true

      def additional_code
        super || user_session.additional_code[measure_type_id]
      end

      def save
        user_session.additional_code = {
          measure_type_id => additional_code,
        }
      end

      def options_for_select
        available_additional_codes.map { |ac| build_option(ac['code'], ac['overlay']) }
      end

      def next_step_path
        return confirm_path if next_measure_type_id.nil?

        additional_codes_path(next_measure_type_id)
      end

      def previous_step_path; end

      private

      def available_additional_codes
        @available_additional_codes ||= applicable_additional_codes[measure_type_id]['additional_codes']
      end

      def build_option(code, overlay)
        OpenStruct.new(
          id: code,
          name: "#{code} - #{overlay}".html_safe,
        )
      end

      def next_measure_type_id
        return nil if next_measure_type_index > available_measure_types.size - 1

        available_measure_types[next_measure_type_index]
      end

      def available_measure_types
        @available_measure_types ||= applicable_additional_codes.keys
      end

      def next_measure_type_index
        @next_measure_type_index ||= available_measure_types.find_index(measure_type_id) + 1
      end
    end
  end
end
