module Steps
  class DocumentCode < Steps::Base
    include CommodityHelper

    STEPS_TO_REMOVE_FROM_SESSION = %w[].freeze

    attribute :measure_type_id, :string
    attribute :document_code_uk, :string
    attribute :document_code_xi, :string

    validates :measure_type_id, presence: true

    def document_code_uk
      super || user_session.document_code_uk[measure_type_id]
    end

    def document_code_xi
      super || user_session.document_code_xi[measure_type_id]
    end

    def save
      user_session.document_code_uk = { measure_type_id => document_code_uk }
      user_session.document_code_xi = { measure_type_id => document_code_xi }
    end

    def options_for_select_for(source:)
      available_document_codes_for(source: source).map { |doc| build_option(doc, doc) if doc.present? }.compact
    end

    def measure_type_description_for(source:)
      applicable_document_codes[source][measure_type_id]['measure_type_description'].downcase
    end

    def next_step_path
    end

    def previous_step_path; end

    private

    def available_document_codes_for(source:)
      return {} if applicable_document_codes.blank? || applicable_document_codes[source][measure_type_id].blank?

      applicable_document_codes[source][measure_type_id]
    end

    def build_option(code, _description)
      OpenStruct.new(
        id: code,
        name: code.to_s.html_safe,
      )
    end

    def next_measure_type_id
      return nil if next_measure_type_index > applicable_measure_type_ids.size - 1

      applicable_measure_type_ids[next_measure_type_index]
    end

    def previous_measure_type_id
      return nil if previous_measure_type_index.negative?

      applicable_measure_type_ids[previous_measure_type_index]
    end

    def next_measure_type_index
      @next_measure_type_index ||= applicable_measure_type_ids.find_index(measure_type_id) + 1
    end

    def previous_measure_type_index
      @previous_measure_type_index ||= applicable_measure_type_ids.find_index(measure_type_id) - 1
    end
  end
end
