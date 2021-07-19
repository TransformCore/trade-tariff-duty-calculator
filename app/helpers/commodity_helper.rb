module CommodityHelper
  def filtered_commodity(filter: default_filter, source: user_session.commodity_source)
    commodity_source = source || user_session.commodity_source
    commodity_code = user_session.commodity_code
    query = default_query.merge(filter)

    commodity_context_service.call(commodity_source, commodity_code, query)
  end

  def commodity
    commodity_source = user_session.commodity_source
    commodity_code = user_session.commodity_code

    commodity_context_service.call(commodity_source, commodity_code, default_query)
  end

  def applicable_additional_codes
    @applicable_additional_codes ||=
      {}.tap do |additional_codes|
        if user_session.deltas_applicable?
          additional_codes['uk'] = filtered_commodity(source: 'uk').applicable_additional_codes.slice(
            *Api::MeasureType::SUPPORTED_MEASURE_TYPE_IDS,
          )

          additional_codes['xi'] = filtered_commodity(source: 'xi').applicable_additional_codes.slice(
            *Api::MeasureType::SUPPORTED_MEASURE_TYPE_IDS,
          )
        else
          additional_codes[user_session.commodity_source] = filtered_commodity.applicable_additional_codes.slice(
            *Api::MeasureType::SUPPORTED_MEASURE_TYPE_IDS,
          )
        end
      end
  end

  def applicable_document_codes
    document_codes = filtered_commodity.import_measures.each_with_object({}) do |measure, acc|
      next if measure.document_codes.blank?

      acc[measure.measure_type.id] ||= []
      acc[measure.measure_type.id].concat(measure.document_codes)
    end

    {
      user_session.commodity_source => document_codes.slice(
        *Api::MeasureType::SUPPORTED_MEASURE_TYPE_IDS,
      ),
    }
  end

  def applicable_document_codes?
    applicable_document_codes.values.any?(&:present?)
  end

  def applicable_additional_codes?
    applicable_additional_codes.values.any?(&:present?)
  end

  def applicable_measure_type_ids
    @applicable_measure_type_ids ||= applicable_additional_codes.flat_map { |_service, additional_codes| additional_codes.keys }.uniq
  end

  def applicable_vat_options
    @applicable_vat_options ||= filtered_commodity(source: 'uk').applicable_vat_options
  end

  def applicable_measure_units
    return filtered_commodity.applicable_measure_units unless user_session.deltas_applicable?

    uk_measure_units.merge(xi_measure_units)
  end

  def applicable_measure_unit_keys
    applicable_measure_units.keys.map(&:downcase)
  end

  private

  def commodity_context_service
    Thread.current[:commodity_context_service]
  end

  def default_filter
    { 'filter[geographical_area_id]' => country_of_origin_code }
  end

  def default_query
    { 'as_of' => (user_session.import_date || Time.zone.today).iso8601 }
  end

  def country_of_origin_code
    return user_session.other_country_of_origin if user_session.country_of_origin == 'OTHER'

    user_session.country_of_origin
  end

  def uk_measure_units
    filtered_commodity(source: 'uk').applicable_measure_units
  end

  def xi_measure_units
    filtered_commodity(source: 'xi').applicable_measure_units
  end
end
