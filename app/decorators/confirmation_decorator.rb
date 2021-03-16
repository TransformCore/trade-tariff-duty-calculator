class ConfirmationDecorator < SimpleDelegator
  ORDERED_STEPS = %w[
    import_date
    import_destination
    country_of_origin
    trader_scheme
    final_use
    planned_processing
    certificate_of_origin
    customs_value
    measure_amount
  ].freeze

  def initialize(object, commodity)
    super(object)

    @commodity = commodity
  end

  def path_for(key:, commodity_code:, service_choice:)
    send("#{key}_path", commodity_code: commodity_code, service_choice: service_choice)
  end

  def user_answers
    ORDERED_STEPS.each_with_object([]) do |(k, _v), acc|
      next if session_answers[k].blank? || (formatted_value = format_value_for(k)).nil?

      acc << {
        key: k,
        label: I18n.t("confirmation_page.#{k}"),
        value: formatted_value,
      }
    end
  end

  def formatted_commodity_code
    "#{commodity.code[0..3]} #{commodity.code[4..5]} #{commodity.code[6..7]} #{commodity.code[8..9]}"
  end

  private

  attr_reader :commodity

  def format_value_for(key)
    value = session_answers[key]

    return format_import_date(value) if key == 'import_date'
    return format_customs_value(value) if key == 'customs_value'
    return format_measure_amount(value) if key == 'measure_amount'
    return format_country(value) if %w[import_destination country_of_origin].include?(key)

    value.humanize
  end

  def session_answers
    @session_answers ||= user_session.session['answers']
  end

  def format_measure_amount(value)
    return if commodity.applicable_measure_units.blank?

    value.map { |k, v| "#{v} #{commodity.applicable_measure_units[k.upcase]['unit']}" }
         .join('<br>')
         .html_safe
  end

  def format_customs_value(value)
    "£#{value.values.map(&:to_f).reduce(:+)}"
  end

  def format_import_date(value)
    Date.parse(value).strftime('%d %B %Y')
  end

  def format_country(value)
    Api::GeographicalArea.find(value).description
  end
end