Dir[File.join(__dir__, '../../app/models/steps/', '*.rb')].sort.each { |file| require_relative file }

POSSIBLE_ANSWERS = Steps.constants.map { |step| "Steps::#{step}".constantize.id }

FactoryBot.define do
  factory :user_session do
    commodity_code   { nil }
    commodity_source { nil }
    referred_service { nil }
    trade_defence    { nil }
    zero_mfn_duty    { nil }
    other_country_of_origin { '' }

    initialize_with do
      answers = POSSIBLE_ANSWERS.each_with_object({}) do |answer_method, acc|
        acc[answer_method] = public_send(answer_method) if respond_to?(answer_method)
      end

      session = { 'answers' => answers.merge('other_country_of_origin' => other_country_of_origin) }
      session.merge!(attributes.stringify_keys.except(*answers.keys))

      UserSession.new(session)
    end
  end

  trait :with_commodity_information do
    commodity_code { '0702000007' }
    commodity_source { 'uk' }
    referred_service { 'uk' }
  end

  trait :with_import_date do
    import_date { '2025-01-01' }
  end

  trait :with_import_destination do
    import_destination { 'XI' }
  end

  trait :with_country_of_origin do
    country_of_origin { 'GB' }
    other_country_of_origin { '' }
  end

  trait :with_trader_scheme do
    trader_scheme { 'no' }
  end

  trait :with_certificate_of_origin do
    certificate_of_origin { 'yes' }
  end

  trait :with_customs_value do
    customs_value { {  'monetary_value' => '1200' } }
  end

  trait :with_measure_amount do
    measure_amount { { 'dtn' => '100' } }
  end

  trait :deltas_applicable do
    import_destination { 'XI' }
    country_of_origin { 'OTHER' }
    other_country_of_origin { 'AR' }
    planned_processing { 'commercial_processing' }
  end

  trait :with_vat do
    vat { 'VATZ' }
  end

  trait :with_additional_codes do
    additional_code do
      {
        'uk' => {
          '105' => '2340',
          '103' => '2600',
        },
        'xi' => {
          '105' => '2340',
          '103' => '2600',
        },
      }
    end
  end

  trait :with_document_codes do
    document_code do
      {
        'uk' => {
          '103' => ['N851', ''],
          '105' => ['C644', 'Y929', ''],
        },
        'xi' => {
          '142' => ['N851', ''],
          '353' => ['C644', 'Y929', ''],
        },
      }
    end
  end

  trait :with_no_duty_route_eu do
    country_of_origin { 'RO' }
    import_destination { 'XI' }
  end

  trait :with_no_duty_route_gb do
    country_of_origin { 'XI' }
    import_destination { 'UK' }
  end

  trait :with_possible_duty_route_into_ni do
    country_of_origin { 'GB' }
    import_destination { 'XI' }
  end

  trait :with_possible_duty_route_into_gb do
    country_of_origin { 'IN' }
    import_destination { 'UK' }
  end

  trait :zero_mfn_duty do
    zero_mfn_duty { true }
  end
end
