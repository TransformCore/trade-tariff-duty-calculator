RSpec.describe CommodityHelper do
  before do
    allow(helper).to receive(:user_session).and_return(user_session)
    allow(Api::Commodity).to receive(:build).and_call_original
    allow(Thread.current[:commodity_context_service]).to receive(:call).and_call_original
  end

  let(:commodity_source) { 'xi' }
  let(:commodity_code) { '0809400500' }
  let(:import_destination) { 'XI' }
  let(:as_of) { Time.zone.today.iso8601 }

  let(:user_session) do
    build(
      :user_session,
      import_destination: import_destination,
      country_of_origin: 'GB',
      commodity_source: commodity_source,
      commodity_code: commodity_code,
    )
  end

  let(:expected_filter) do
    {
      'as_of' => Time.zone.today.iso8601,
      'filter[geographical_area_id]' => 'GB',
    }
  end

  describe '#filtered_commodity' do
    it 'retrieves commodities via the CommodityContextService' do
      helper.filtered_commodity

      expect(Thread.current[:commodity_context_service]).to have_received(:call).with(commodity_source, commodity_code, expected_filter)
    end

    context 'when the commodity source is passed' do
      it 'uses the passed commodity source' do
        helper.filtered_commodity(source: 'uk')

        expect(Api::Commodity).to have_received(:build).with(
          'uk',
          commodity_code,
          expected_filter,
        )
      end
    end

    context 'when not on RoW to NI route' do
      let(:user_session) do
        build(
          :user_session,
          import_destination: import_destination,
          country_of_origin: 'GB',
          commodity_source: commodity_source,
          commodity_code: commodity_code,
          other_country_of_origin: '',
        )
      end

      it 'returns a correctly filtered commodity' do
        helper.filtered_commodity

        expect(Api::Commodity).to have_received(:build).with(
          commodity_source,
          commodity_code,
          expected_filter,
        )
      end
    end

    context 'when on RoW to NI route' do
      let(:user_session) do
        build(
          :user_session,
          import_destination: import_destination,
          country_of_origin: 'OTHER',
          commodity_source: commodity_source,
          commodity_code: commodity_code,
          other_country_of_origin: 'AR',
        )
      end

      let(:expected_filter) do
        {
          'as_of' => Time.zone.today.iso8601,
          'filter[geographical_area_id]' => 'AR',
        }
      end

      it 'returns a correctly filtered commodity' do
        helper.filtered_commodity

        expect(Api::Commodity).to have_received(:build).with(
          commodity_source,
          commodity_code,
          expected_filter,
        )
      end
    end
  end

  describe '#commodity' do
    let(:user_session) do
      build(
        :user_session,
        import_destination: import_destination,
        commodity_source: commodity_source,
        commodity_code: commodity_code,
      )
    end

    let(:expected_filter) do
      {
        'as_of' => Time.zone.today.iso8601,
      }
    end

    it 'retrieves commodities via the CommodityContextService' do
      helper.commodity

      expect(Thread.current[:commodity_context_service]).to have_received(:call).with(commodity_source, commodity_code, expected_filter)
    end

    it 'returns an unfiltered commodity' do
      helper.commodity

      expect(Api::Commodity).to have_received(:build).with(
        commodity_source,
        commodity_code,
        expected_filter,
      )
    end
  end

  describe '#applicable_vat_options' do
    let(:expected_options) do
      {
        'VAT' => 'Value added tax (20.0)',
        'VATR' => 'VAT reduced rate 5% (5.0)',
        'VATZ' => 'VAT zero rate (0.0)',
      }
    end

    it 'returns the applicable vat options' do
      expect(helper.applicable_vat_options).to eq(expected_options)
    end

    it 'always fetches data from the uk source' do
      helper.applicable_vat_options

      expect(Api::Commodity).to have_received(:build).with(
        'uk',
        commodity_code,
        expected_filter,
      )
    end
  end

  describe '#applicable_additional_codes' do
    let(:expected_options) do
      {
        'xi' => {
          '105' => {
            'additional_codes' => [
              {
                'code' => '2600',
                'hint' => "Read more about the <a target='_blank' href='https://www.gov.uk/government/news/hmg-suspends-import-tariffs-on-covid-19-products-to-fight-virus'>suspension of tariffs on COVID-19 critical goods [opens in a new browser window]</a>",
                'measure_sid' => 20_126_513,
                'overlay' => 'The product I am importing is COVID-19 critical',
              },
              {
                'code' => '2601',
                'hint' => '',
                'measure_sid' => 20_126_512,
                'overlay' => 'The product I am importing is not COVID-19 critical',
              },
            ],
            'heading' => {
              'hint' => 'To trade this commodity, you need to specify an additional 4 digits, known as an additional code',
              'overlay' => 'Describe your goods in more detail',
            },
            'measure_type_description' => 'Non preferential duty under authorised use',
          },
        },
      }
    end

    it 'returns the applicable additional codes' do
      expect(helper.applicable_additional_codes).to eq(expected_options)
    end
  end

  describe '#applicable_document_codes' do
    let(:expected_options) do
      {
        '103' => ['N851', ''],
        '105' => ['C644', 'Y929', ''],
      }
    end

    it 'returns the applicable document codes' do
      expect(helper.applicable_document_codes).to eq(expected_options)
    end
  end

  describe '#applicable_measure_units' do
    let(:expected_measure_units) do
      {
        'DTN' => {
          'abbreviation' => '100 kg',
          'measure_sids' => [20_005_920, 20_056_507, 20_073_335, 20_076_779, 20_090_066, 20_105_690, 20_078_066, 20_102_998, 20_108_866, 20_085_014],
          'measurement_unit_code' => 'DTN',
          'measurement_unit_qualifier_code' => '',
          'unit' => 'x 100 kg',
          'unit_hint' => 'Enter the value in decitonnes (100kg)',
          'unit_question' => 'What is the weight of the goods you will be importing?',
        },
      }
    end

    context 'when deltas are applicable' do
      let(:user_session) { build(:user_session, :with_commodity_information, :deltas_applicable) }

      it 'fetches the uk commodity' do
        helper.applicable_measure_units

        expect(Api::Commodity).to have_received(:build).with('uk', anything, anything)
      end

      it 'fetches the xi commodity' do
        helper.applicable_measure_units

        expect(Api::Commodity).to have_received(:build).with('xi', anything, anything)
      end

      it 'fetches the measure units' do
        expect(helper.applicable_measure_units).to eq(expected_measure_units)
      end
    end

    context 'when deltas are not applicable' do
      let(:user_session) { build(:user_session, :with_commodity_information) }

      it 'fetches the uk commodity' do
        helper.applicable_measure_units

        expect(Api::Commodity).to have_received(:build).with('uk', anything, anything)
      end

      it 'does not fetch the xi commodity' do
        helper.applicable_measure_units

        expect(Api::Commodity).not_to have_received(:build).with('xi', anything, anything)
      end

      it 'fetches the measure units' do
        expect(helper.applicable_measure_units).to eq(expected_measure_units)
      end
    end
  end

  describe '#applicable_measure_unit_keys' do
    let(:user_session) { build(:user_session, :with_commodity_information) }

    it 'returns the keys of the applicable_measure_units' do
      expect(helper.applicable_measure_unit_keys).to eq(%w[dtn])
    end
  end
end
