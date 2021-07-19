class UserSession
  attr_reader :session

  def initialize(session)
    @session = session
    @session['answers'] ||= {}
    @session['answers'][Steps::AdditionalCode.id] ||= { 'xi' => {}, 'uk' => {} }
    @session['answers'][Steps::DocumentCode.id] ||= { 'xi' => {}, 'uk' => {} }
  end

  def remove_step_ids(ids)
    ids.map { |id| session['answers'].delete(id) } unless ids.empty?
  end

  def import_date
    return if session['answers'][Steps::ImportDate.id].blank?

    Date.parse(session['answers'][Steps::ImportDate.id])
  end

  def import_date=(value)
    session['answers'][Steps::ImportDate.id] = value
  end

  def import_destination
    session['answers'][Steps::ImportDestination.id]
  end

  def import_destination=(value)
    session['answers'][Steps::ImportDestination.id] = value
  end

  def country_of_origin
    session['answers'][Steps::CountryOfOrigin.id]
  end

  def country_of_origin=(value)
    session['answers'][Steps::CountryOfOrigin.id] = value
  end

  def other_country_of_origin
    session['answers']['other_country_of_origin']
  end

  def other_country_of_origin=(value)
    session['answers']['other_country_of_origin'] = value
  end

  def trader_scheme
    session['answers'][Steps::TraderScheme.id]
  end

  def trader_scheme=(value)
    session['answers'][Steps::TraderScheme.id] = value
  end

  def final_use
    session['answers'][Steps::FinalUse.id]
  end

  def final_use=(value)
    session['answers'][Steps::FinalUse.id] = value
  end

  def certificate_of_origin
    session['answers'][Steps::CertificateOfOrigin.id]
  end

  def certificate_of_origin=(value)
    session['answers'][Steps::CertificateOfOrigin.id] = value
  end

  def planned_processing
    session['answers'][Steps::PlannedProcessing.id]
  end

  def planned_processing=(value)
    session['answers'][Steps::PlannedProcessing.id] = value
  end

  def trade_defence
    session['trade_defence']
  end

  def trade_defence=(value)
    session['trade_defence'] = value
  end

  def zero_mfn_duty
    session['zero_mfn_duty']
  end

  def zero_mfn_duty=(value)
    session['zero_mfn_duty'] = value
  end

  def customs_value
    session['answers'][Steps::CustomsValue.id]
  end

  def customs_value=(values)
    session['answers'][Steps::CustomsValue.id] = {
      'monetary_value' => values['monetary_value'],
      'shipping_cost' => values['shipping_cost'],
      'insurance_cost' => values['insurance_cost'],
    }
  end

  def additional_code_uk=(value)
    session['answers'][Steps::AdditionalCode.id]['uk'].merge!(value)
  end

  def additional_code_xi=(value)
    session['answers'][Steps::AdditionalCode.id]['xi'].merge!(value)
  end

  def document_code_uk=(value)
    session['answers'][Steps::DocumentCode.id]['uk'].merge!(value)
  end

  def document_code_xi=(value)
    session['answers'][Steps::DocumentCode.id]['xi'].merge!(value)
  end

  def additional_code_uk
    session['answers'][Steps::AdditionalCode.id]['uk']
  end

  def additional_code_xi
    session['answers'][Steps::AdditionalCode.id]['xi']
  end

  def document_code_uk
    session['answers'][Steps::DocumentCode.id]['uk']
  end

  def document_code_xi
    session['answers'][Steps::DocumentCode.id]['xi']
  end

  def measure_type_ids
    session['answers'][Steps::AdditionalCode.id][commodity_source].keys
  end

  def commodity_source=(value)
    session['commodity_source'] = value
  end

  def commodity_source
    session['commodity_source']
  end

  def referred_service=(value)
    session['referred_service'] = value
  end

  def referred_service
    session['referred_service']
  end

  def commodity_code=(value)
    session['commodity_code'] = value
  end

  def commodity_code
    session['commodity_code']
  end

  def measure_amount=(values)
    session['answers'][Steps::MeasureAmount.id] = values
  end

  def measure_amount
    session['answers'][Steps::MeasureAmount.id] || {}
  end

  def vat=(values)
    session['answers'][Steps::Vat.id] = values
  end

  def vat
    session['answers'][Steps::Vat.id]
  end

  def monetary_value
    session['answers'][Steps::CustomsValue.id].try(:[], 'monetary_value')
  end

  def shipping_cost
    session['answers'][Steps::CustomsValue.id].try(:[], 'shipping_cost')
  end

  def insurance_cost
    session['answers'][Steps::CustomsValue.id].try(:[], 'insurance_cost')
  end

  def ni_to_gb_route?
    import_destination == 'UK' && country_of_origin == 'XI'
  end

  def gb_to_ni_route?
    import_destination == 'XI' && country_of_origin == 'GB'
  end

  def eu_to_ni_route?
    import_destination == 'XI' && Api::GeographicalArea.eu_member?(country_of_origin)
  end

  def row_to_gb_route?
    import_destination == 'UK' && country_of_origin != 'XI'
  end

  def row_to_ni_route?
    import_destination == 'XI' && country_of_origin == 'OTHER' && other_country_of_origin.present?
  end

  def total_amount
    customs_value.values.map(&:to_f).reduce(:+)
  end

  def additional_codes
    (additional_code_uk.values + additional_code_xi.values).compact.join(', ')
  end

  def deltas_applicable?
    row_to_ni_route? && planned_processing != 'commercial_purposes'
  end

  def import_into_gb?
    import_destination == 'UK'
  end

  def no_duty_to_pay?
    no_duty_route? || possible_duty_route? && no_duty_applies?
  end

  private

  def no_duty_route?
    ni_to_gb_route? || eu_to_ni_route?
  end

  def possible_duty_route?
    gb_to_ni_route? || row_to_gb_route?
  end

  def no_duty_applies?
    zero_mfn_duty_no_trade_defence? || strict_processing? || certificate_of_origin?
  end

  def strict_processing?
    planned_processing.in?(%w[without_any_processing annual_turnover commercial_processing])
  end

  def zero_mfn_duty_no_trade_defence?
    !trade_defence && zero_mfn_duty
  end

  def certificate_of_origin?
    certificate_of_origin == 'yes'
  end
end
