RSpec.describe UserSession do
  subject(:user_session) { build(:user_session) }

  let(:session) { user_session.session }

  describe '#import_date' do
    subject(:user_session) { build(:user_session) }

    it 'returns nil if the key is not on the session' do
      expect(user_session.import_date).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, import_date: '2025-01-01') }

      let(:expected_date) { Date.parse('2025-01-01') }

      it 'returns the value from the session' do
        expect(user_session.import_date).to eq(expected_date)
      end
    end
  end

  describe '#import_date=' do
    let(:expected_date) { '2025-01-01' }

    it 'sets the key on the session' do
      user_session.import_date = '2025-01-01'

      expect(session['answers'][Steps::ImportDate.id]).to eq(expected_date)
    end
  end

  describe '#import_destination' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.import_destination).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, import_destination: 'ni') }

      let(:expected_country) { 'ni' }

      it 'returns the value from the session' do
        expect(user_session.import_destination).to eq(expected_country)
      end
    end
  end

  describe '#vat=' do
    let(:expected_value) { 'VATZ' }

    it 'sets the key on the session' do
      user_session.vat = 'VATZ'

      expect(session['answers'][Steps::Vat.id]).to eq(expected_value)
    end
  end

  describe '#vat' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.vat).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, vat: 'VATZ') }

      it 'returns the value from the session' do
        expect(user_session.vat).to eq('VATZ')
      end
    end
  end

  describe '#import_destination=' do
    let(:expected_country) { 'ni' }

    it 'sets the key on the session' do
      user_session.import_destination = 'ni'

      expect(session['answers'][Steps::ImportDestination.id]).to eq(expected_country)
    end
  end

  describe '#trader_scheme' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.trader_scheme).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, trader_scheme: 'yes') }

      let(:expected_response) { 'yes' }

      it 'returns the value from the session' do
        expect(user_session.trader_scheme).to eq(expected_response)
      end
    end
  end

  describe '#trader_scheme=' do
    let(:expected_response) { 'yes' }

    it 'sets the key on the session' do
      user_session.trader_scheme = 'yes'

      expect(session['answers'][Steps::TraderScheme.id]).to eq(expected_response)
    end
  end

  describe '#final_use' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.final_use).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, final_use: 'yes') }

      let(:expected_response) { 'yes' }

      it 'returns the value from the session' do
        expect(user_session.final_use).to eq(expected_response)
      end
    end
  end

  describe '#final_use=' do
    let(:expected_response) { 'yes' }

    it 'sets the key on the session' do
      user_session.final_use = 'yes'

      expect(session['answers'][Steps::FinalUse.id]).to eq(expected_response)
    end
  end

  describe '#planned_processing' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.planned_processing).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, planned_processing: 'without_any_processing') }

      let(:expected_response) { 'without_any_processing' }

      it 'returns the value from the session' do
        expect(user_session.planned_processing).to eq(expected_response)
      end
    end
  end

  describe '#planned_processing=' do
    let(:expected_response) { 'without_any_processing' }

    it 'sets the key for without any processing in the session' do
      user_session.planned_processing = 'without_any_processing'

      expect(session['answers'][Steps::PlannedProcessing.id]).to eq(expected_response)
    end
  end

  describe '#certificate_of_origin' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.certificate_of_origin).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, certificate_of_origin: 'yes') }

      let(:expected_response) { 'yes' }

      it 'returns the value from the session' do
        expect(user_session.certificate_of_origin).to eq(expected_response)
      end
    end
  end

  describe '#certificate_of_origin=' do
    let(:expected_response) { 'yes' }

    it 'sets the key on the session' do
      user_session.certificate_of_origin = 'yes'

      expect(session['answers'][Steps::CertificateOfOrigin.id]).to eq(expected_response)
    end
  end

  describe '#country_of_origin' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.country_of_origin).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, :with_commodity_information, country_of_origin: 'GB') }

      let(:expected_country) { 'GB' }

      it 'returns the value from the session' do
        expect(user_session.country_of_origin).to eq(expected_country)
      end
    end
  end

  describe '#country_of_origin=' do
    let(:expected_country) { 'GB' }

    it 'sets the key on the session' do
      user_session.country_of_origin = 'GB'

      expect(session['answers'][Steps::CountryOfOrigin.id]).to eq(expected_country)
    end
  end

  describe '#other_country_of_origin=' do
    let(:expected_country) { 'AR' }

    it 'sets the key on the session' do
      user_session.other_country_of_origin = 'AR'

      expect(session['answers']['other_country_of_origin']).to eq(expected_country)
    end
  end

  describe '#other_country_of_origin' do
    it 'returns empty string if the key is not on the session' do
      expect(user_session.other_country_of_origin).to be_empty
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, country_of_origin: 'OTHER', other_country_of_origin: 'AR') }

      let(:expected_country) { 'AR' }

      it 'returns the value from the session' do
        expect(user_session.other_country_of_origin).to eq(expected_country)
      end
    end
  end

  describe '#trade_defence' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.trade_defence).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, trade_defence: true) }

      it 'returns the value from the session' do
        expect(user_session.trade_defence).to eq(true)
      end
    end
  end

  describe '#trade_defence=' do
    it 'sets the key on the session' do
      user_session.trade_defence = true

      expect(session['trade_defence']).to eq(true)
    end
  end

  describe '#zero_mfn_duty' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.zero_mfn_duty).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, zero_mfn_duty: true) }

      it 'returns the value from the session' do
        expect(user_session.zero_mfn_duty).to eq(true)
      end
    end
  end

  describe '#zero_mfn_duty=' do
    it 'sets the key on the session' do
      user_session.zero_mfn_duty = true

      expect(session['zero_mfn_duty']).to eq(true)
    end
  end

  describe '#insurance_cost' do
    subject(:user_session) { build(:user_session, customs_value: { 'insurance_cost' => '340' }) }

    it 'returns the correct value from the session' do
      expect(user_session.insurance_cost).to eq('340')
    end
  end

  describe '#shipping_cost' do
    subject(:user_session) { build(:user_session, customs_value: { 'shipping_cost' => '1_200' }) }

    it 'returns the correct value from the session' do
      expect(user_session.shipping_cost).to eq('1_200')
    end
  end

  describe '#monetary_value' do
    subject(:user_session) { build(:user_session, customs_value: { 'monetary_value' => '12000' }) }

    it 'returns the correct value from the session' do
      expect(user_session.monetary_value).to eq('12000')
    end
  end

  describe '#customs_value=' do
    let(:value) do
      {
        'monetary_value' => 12_000,
        'shipping_cost' => 1_200,
        'insurance_cost' => 340,
      }
    end

    it 'stores the hash on the session' do
      user_session.customs_value = value

      expect(session['answers'][Steps::CustomsValue.id]).to eq(value)
    end
  end

  describe '#measure_amount' do
    subject(:user_session) { build(:user_session, measure_amount: { foo: :bar }) }

    it 'returns the correct value from the session' do
      expect(user_session.measure_amount).to eq(foo: :bar)
    end
  end

  describe '#measure_amount=' do
    let(:value) { {} }

    it 'stores the hash on the session' do
      user_session.measure_amount = value

      expect(session['answers'][Steps::MeasureAmount.id]).to eq(value)
    end
  end

  describe '#additional_code_uk' do
    subject(:user_session) do
      build(
        :user_session,
        :with_commodity_information,
        :with_additional_codes,
      )
    end

    it 'returns the correct value from the session for the uk source' do
      expect(user_session.additional_code_uk).to eq({ '103' => '2600', '105' => '2340' })
    end
  end

  describe '#additional_code_xi' do
    subject(:user_session) do
      build(
        :user_session,
        :with_commodity_information,
        :with_additional_codes,
      )
    end

    it 'returns the correct value from the session for the uk source' do
      expect(user_session.additional_code_xi).to eq({ '103' => '2600', '105' => '2340' })
    end
  end

  describe '#document_code_uk' do
    subject(:user_session) do
      build(
        :user_session,
        :with_commodity_information,
        :with_document_codes,
      )
    end

    let(:expected_value) do
      { '103' => ['N851', ''], '105' => ['C644', 'Y929', ''] }
    end

    it 'returns the correct value from the session for the uk source' do
      expect(user_session.document_code_uk).to eq(expected_value)
    end
  end

  describe '#document_code_xi' do
    subject(:user_session) do
      build(
        :user_session,
        :with_commodity_information,
        :with_document_codes,
      )
    end

    let(:expected_value) do
      { '142' => ['N851', ''], '353' => ['C644', 'Y929', ''] }
    end

    it 'returns the correct value from the session for the uk source' do
      expect(user_session.document_code_xi).to eq(expected_value)
    end
  end

  describe '#additional_code_uk=' do
    let(:value) { { '105' => '2300' } }
    let(:expected_value) do
      { 'uk' => { '105' => '2300' }, 'xi' => {} }
    end
    let(:new_value) { { '104' => '2511' } }

    let(:merged_session) do
      {
        'uk' => {
          '105' => '2300',
          '104' => '2511',
        },
        'xi' => {},
      }
    end

    before do
      user_session.additional_code_uk = value
    end

    it 'stores the hash on the session' do
      expect(session['answers'][Steps::AdditionalCode.id]).to eq(expected_value)
    end

    it 'merges new additional codes to the existing ones' do
      user_session.additional_code_uk = new_value

      expect(session['answers'][Steps::AdditionalCode.id]).to eq(merged_session)
    end
  end

  describe '#document_code_uk=' do
    let(:value) { { '103' => ['N851', ''] } }

    let(:expected_value) do
      { 'uk' => { '103' => ['N851', ''] }, 'xi' => {} }
    end
    let(:new_value) { { '105' => ['C644', 'Y929', ''] } }

    let(:merged_session) do
      {
        'uk' => {
          '103' => ['N851', ''],
          '105' => ['C644', 'Y929', ''],
        },
        'xi' => {},
      }
    end

    before do
      user_session.document_code_uk = value
    end

    it 'stores the hash on the session' do
      expect(session['answers'][Steps::DocumentCode.id]).to eq(expected_value)
    end

    it 'merges new additional codes to the existing ones' do
      user_session.document_code_uk = new_value

      expect(session['answers'][Steps::DocumentCode.id]).to eq(merged_session)
    end
  end

  describe '#document_code_xi=' do
    let(:value) { { '142' => ['N851', ''] } }

    let(:expected_value) do
      { 'xi' => { '142' => ['N851', ''] }, 'uk' => {} }
    end
    let(:new_value) { { '353' => ['C644', 'Y929', ''] } }

    let(:merged_session) do
      {
        'xi' => {
          '142' => ['N851', ''],
          '353' => ['C644', 'Y929', ''],
        },
        'uk' => {},
      }
    end

    before do
      user_session.document_code_xi = value
    end

    it 'stores the hash on the session' do
      expect(session['answers'][Steps::DocumentCode.id]).to eq(expected_value)
    end

    it 'merges new additional codes to the existing ones' do
      user_session.document_code_xi = new_value

      expect(session['answers'][Steps::DocumentCode.id]).to eq(merged_session)
    end
  end

  describe '#additional_code_xi=' do
    let(:value) { { '105' => '2300' } }
    let(:expected_value) do
      { 'xi' => { '105' => '2300' }, 'uk' => {} }
    end
    let(:new_value) { { '104' => '2511' } }

    let(:merged_session) do
      {
        'xi' => {
          '105' => '2300',
          '104' => '2511',
        },
        'uk' => {},
      }
    end

    before do
      user_session.additional_code_xi = value
    end

    it 'stores the hash on the session' do
      expect(session['answers'][Steps::AdditionalCode.id]).to eq(expected_value)
    end

    it 'merges new additional codes to the existing ones' do
      user_session.additional_code_xi = new_value

      expect(session['answers'][Steps::AdditionalCode.id]).to eq(merged_session)
    end
  end

  describe '#measure_type_ids' do
    subject(:user_session) do
      build(
        :user_session,
        :with_additional_codes,
        :with_commodity_information,
      )
    end

    it 'returns the measure type ids from the session' do
      expect(user_session.measure_type_ids).to eq(%w[105 103])
    end
  end

  describe '#commodity_code' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.commodity_code).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, commodity_code: '1111111111') }

      it 'returns the value from the session' do
        expect(user_session.commodity_code).to eq('1111111111')
      end
    end
  end

  describe '#commodity_code=' do
    it 'sets the key on the session' do
      user_session.commodity_code = '1111111111'

      expect(session['commodity_code']).to eq('1111111111')
    end
  end

  describe '#commodity_source' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.commodity_source).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, commodity_source: 'uk') }

      it 'returns the value from the session' do
        expect(user_session.commodity_source).to eq('uk')
      end
    end
  end

  describe '#commodity_source=' do
    it 'sets the key on the session' do
      user_session.commodity_source = 'uk'

      expect(session['commodity_source']).to eq('uk')
    end
  end

  describe '#referred_service' do
    it 'returns nil if the key is not on the session' do
      expect(user_session.referred_service).to be nil
    end

    context 'when the key is present on the session' do
      subject(:user_session) { build(:user_session, referred_service: 'uk') }

      it 'returns the value from the session' do
        expect(user_session.referred_service).to eq('uk')
      end
    end
  end

  describe '#referred_service=' do
    it 'sets the key on the session' do
      user_session.referred_service = 'uk'

      expect(session['referred_service']).to eq('uk')
    end
  end

  describe '#ni_to_gb_route?' do
    context 'when import country is GB and origin country is NI' do
      subject(:user_session) { build(:user_session, import_destination: 'UK', country_of_origin: 'XI') }

      it 'returns true' do
        expect(user_session.ni_to_gb_route?).to be true
      end
    end

    it 'returns false otherwise' do
      expect(user_session.ni_to_gb_route?).to be false
    end
  end

  describe '#eu_to_ni_route?' do
    context 'when import country is NI and origin country is a EU Member' do
      subject(:user_session) { build(:user_session, import_destination: 'XI', country_of_origin: 'RO') }

      it 'returns true' do
        expect(user_session.eu_to_ni_route?).to be true
      end
    end

    it 'returns false otherwise' do
      expect(user_session.eu_to_ni_route?).to be false
    end
  end

  describe '#gb_to_ni_route?' do
    context 'when import country is XI and origin country is GB' do
      subject(:user_session) { build(:user_session, import_destination: 'XI', country_of_origin: 'GB') }

      it 'returns true' do
        expect(user_session.gb_to_ni_route?).to be true
      end
    end

    it 'returns false otherwise' do
      expect(user_session.gb_to_ni_route?).to be false
    end
  end

  describe '#row_to_gb_route?' do
    context 'when import country is UK and origin country is anything but XI' do
      subject(:user_session) { build(:user_session, import_destination: 'UK', country_of_origin: 'RO') }

      it 'returns true' do
        expect(user_session.row_to_gb_route?).to be true
      end
    end

    it 'returns false otherwise' do
      expect(user_session.row_to_gb_route?).to be false
    end
  end

  describe '#row_to_ni_route?' do
    context 'when import country is XI and origin country is anything but GB or any EU member' do
      subject(:user_session) do
        build(
          :user_session,
          import_destination: 'XI',
          country_of_origin: 'OTHER',
          other_country_of_origin: 'AR',
        )
      end

      it 'returns true' do
        expect(user_session.row_to_ni_route?).to be true
      end
    end

    it 'returns false otherwise' do
      expect(user_session.row_to_ni_route?).to be false
    end
  end

  describe '#deltas_applicable?' do
    context 'when on RoW to NI route and planned_processing is commercial_purposes' do
      subject(:user_session) do
        build(
          :user_session,
          :deltas_applicable,
        )
      end

      it 'returns true' do
        expect(user_session.deltas_applicable?).to be true
      end
    end

    it 'returns false' do
      expect(user_session.deltas_applicable?).to be false
    end
  end

  describe '#import_into_gb?' do
    subject(:user_session) { build(:user_session, import_destination: import_destination) }

    context 'when the import_destination is UK' do
      let(:import_destination) { 'UK' }

      it { is_expected.to be_import_into_gb }
    end

    context 'when the import_destination is not UK' do
      let(:import_destination) { 'XI' }

      it { is_expected.not_to be_import_into_gb }
    end
  end

  describe '#no_duty_to_pay?' do
    context 'when on a no duty route into ni' do
      subject(:user_session) { build(:user_session, :with_no_duty_route_eu) }

      it { is_expected.to be_no_duty_to_pay }
    end

    context 'when on a no duty route into gb' do
      subject(:user_session) { build(:user_session, :with_no_duty_route_gb) }

      it { is_expected.to be_no_duty_to_pay }
    end

    context 'when on a possible duty_route' do
      %i[with_possible_duty_route_into_gb with_possible_duty_route_into_ni].each do |route_trait|
        context 'when with zero_mfn_duty' do
          subject(:user_session) { build(:user_session, route_trait, :zero_mfn_duty) }

          it { is_expected.to be_no_duty_to_pay }
        end

        context 'when no duty applies' do
          %w[without_any_processing annual_turnover commercial_processing].each do |processing|
            subject(:user_session) { build(:user_session, route_trait, planned_processing: processing) }

            it { is_expected.to be_no_duty_to_pay }
          end
        end

        context 'when the trader has a certificate of origin' do
          subject(:user_session) { build(:user_session, route_trait, :with_certificate_of_origin) }

          it { is_expected.to be_no_duty_to_pay }
        end
      end
    end
  end
end
