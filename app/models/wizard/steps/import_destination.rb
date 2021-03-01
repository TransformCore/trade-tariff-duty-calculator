module Wizard
  module Steps
    class ImportDestination < Wizard::Steps::Base
      OPTIONS = [
        OpenStruct.new(id: 'GB', name: 'England, Scotland or Wales (GB)'),
        OpenStruct.new(id: 'XI', name: 'Northern Ireland'),
      ].freeze

      STEP_ID = '2'.freeze
      STEPS_TO_REMOVE_FROM_SESSION = %w[3 4].freeze

      attribute :import_destination, :string

      validates :import_destination, presence: true

      def import_destination
        super || user_session.import_destination
      end

      def save
        user_session.import_destination = import_destination
      end

      def next_step_path(service_choice:, commodity_code:)
        country_of_origin_path(service_choice: service_choice, commodity_code: commodity_code)
      end

      def previous_step_path(service_choice:, commodity_code:)
        import_date_path(service_choice: service_choice, commodity_code: commodity_code)
      end
    end
  end
end
