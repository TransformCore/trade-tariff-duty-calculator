RSpec.describe Wizard::Steps::AdditionalCode do
  subject(:step) { described_class.new(user_session, attributes) }

  let(:user_session) { build(:user_session, import_date: '2022-01-01') }
  let(:filtered_commodity) { instance_double(Api::Commodity) }
  let(:current_measure_type_id) { '105' }

  let(:attributes) do
    ActionController::Parameters.new(
      measure_type_id: current_measure_type_id,
      additional_code: '2300',
    ).permit(
      :measure_type_id,
      :additional_code,
    )
  end

  let(:additional_codes) do
    {
      '105' => {
        'heading' => {
          'overlay' => 'Describe your goods in more detail',
          'hint' => 'To trade this commodity, you need to specify an additional 4 digits, known as an additional code',
        },
        'additional_codes' => [
          {
            'code' => '2600',
            'overlay' => 'The product I am importing is COVID-19 critical',
            'hint' => "Read more about the <a target='_blank' href='https://www.gov.uk/government/news/hmg-suspends-import-tariffs-on-covid-19-products-to-fight-virus'>suspension of tariffs on COVID-19 critical goods [opens in a new browser window]</a>",
          },
          {
            'code' => '2601',
            'overlay' => 'The product I am importing is not COVID-19 critical',
            'hint' => '',
          },
        ],
      },

      '552' => {
        'heading' => {
          'overlay' => 'Describe your goods in more detail',
          'hint' => 'To trade this commodity, you need to specify an additional 4 digits, known as an additional code',
        },
        'additional_codes' => [
          {
            'code' => 'B999',
            'overlay' => 'Other',
            'hint' => '',
            'type' => 'preference',
            'measure_sid' => '20511102',
          },
          {
            'code' => 'B349',
            'overlay' => 'Hunan Hualian China Industry Co., Ltd; Hunan Hualian Ebillion China Industry Co., Ltd; Hunan Liling Hongguanyao China Industry Co., Ltd; Hunan Hualian Yuxiang China Industry Co., Ltd.',
            'hint' => '',
            'type' => 'preference',
            'measure_sid' => '20511103',
          },
        ],
      },
    }
  end

  before do
    allow(Api::Commodity).to receive(:build).and_return(filtered_commodity)
    allow(filtered_commodity).to receive(:applicable_additional_codes).and_return(additional_codes)
  end

  describe 'STEPS_TO_REMOVE_FROM_SESSION' do
    it 'returns the correct list of steps' do
      expect(described_class::STEPS_TO_REMOVE_FROM_SESSION).to eq(
        %w[],
      )
    end
  end

  describe '#validations' do
    context 'when measure_type_id is missing' do
      let(:attributes) do
        ActionController::Parameters.new(
          measure_type_id: nil,
        ).permit(:measure_type_id)
      end

      it 'is not a valid object' do
        expect(step.valid?).to be false
      end

      it 'adds the correct validation error messages' do
        step.valid?

        expect(step.errors.messages[:measure_type_id].to_a).to eq(
          ['Enter a valid measure type id'],
        )
      end
    end

    context 'when the additional code is not present' do
      let(:attributes) do
        ActionController::Parameters.new(
          additional_code: '',
        ).permit(:additional_code)
      end

      it 'is not a valid object' do
        expect(step.valid?).to be false
      end

      it 'adds the correct validation error messages' do
        step.valid?

        expect(step.errors.messages[:additional_code].to_a).to eq(
          ['Specify a valid additional code'],
        )
      end
    end
  end

  describe '#save' do
    let(:expected_value) { { '105' => '2300' } }

    it 'saves the additional code value on to the session' do
      step.save

      expect(user_session.additional_code).to eq(expected_value)
    end
  end

  describe '#options_for_select' do
    let(:expected_options) do
      [
        OpenStruct.new(
          id: '2600',
          name: '2600 - The product I am importing is COVID-19 critical',
        ),
        OpenStruct.new(
          id: '2601',
          name: '2601 - The product I am importing is not COVID-19 critical',
        ),
      ]
    end

    it 'returns the correct additonal code options for the given measure' do
      expect(step.options_for_select).to eq(expected_options)
    end
  end

  describe '#additional_code' do
    context 'when there are attributes being passed in' do
      it 'returns the additional code attribute value on the active model' do
        expect(step.additional_code).to eq('2300')
      end
    end

    context 'when there is no additonal code being passed in, but the value is on the session' do
      let(:attributes) do
        ActionController::Parameters.new(
          measure_type_id: '105',
        ).permit(
          :measure_type_id,
        )
      end

      let(:session_value) do
        { '105' => '2500', '445' => '5000' }
      end

      let(:user_session) do
        build(
          :user_session,
          import_date: '2022-01-01',
          additional_code: session_value,
        )
      end

      it 'returns the value from the session that corresponds to measure type 105' do
        expect(step.additional_code).to eq('2500')
      end
    end
  end

  describe '#previous_step_path' do
    include Rails.application.routes.url_helpers

    let(:applicable_measure_units) { {} }

    before do
      allow(filtered_commodity).to receive(:applicable_measure_units).and_return(applicable_measure_units)
    end

    context 'when there is just one measure type id available and measure units are available' do
      let(:applicable_measure_units) do
        {
          'DTN' => {
            'measurement_unit_code' => 'DTN',
            'measurement_unit_qualifier_code' => '',
            'abbreviation' => '100 kg',
            'unit_question' => 'What is the weight of the goods you will be importing?',
            'unit_hint' => 'Enter the value in decitonnes (100kg)',
            'unit' => 'x 100 kg',
          },
        }
      end

      let(:additional_codes) do
        {
          '105' => {
            'heading' => {
              'overlay' => 'Describe your goods in more detail',
              'hint' => 'To trade this commodity, you need to specify an additional 4 digits, known as an additional code',
            },
            'additional_codes' => [
              {
                'code' => '2600',
                'overlay' => 'The product I am importing is COVID-19 critical',
                'hint' => "Read more about the <a target='_blank' href='https://www.gov.uk/government/news/hmg-suspends-import-tariffs-on-covid-19-products-to-fight-virus'>suspension of tariffs on COVID-19 critical goods [opens in a new browser window]</a>",
              },
              {
                'code' => '2601',
                'overlay' => 'The product I am importing is not COVID-19 critical',
                'hint' => '',
              },
            ],
          },
        }
      end

      it 'returns the measure_amounts path' do
        expect(step.previous_step_path).to eq(measure_amount_path)
      end
    end

    context 'when there is just one measure type id available and no measure units are available' do
      let(:additional_codes) do
        {
          '105' => {
            'heading' => {
              'overlay' => 'Describe your goods in more detail',
              'hint' => 'To trade this commodity, you need to specify an additional 4 digits, known as an additional code',
            },
            'additional_codes' => [
              {
                'code' => '2600',
                'overlay' => 'The product I am importing is COVID-19 critical',
                'hint' => "Read more about the <a target='_blank' href='https://www.gov.uk/government/news/hmg-suspends-import-tariffs-on-covid-19-products-to-fight-virus'>suspension of tariffs on COVID-19 critical goods [opens in a new browser window]</a>",
              },
              {
                'code' => '2601',
                'overlay' => 'The product I am importing is not COVID-19 critical',
                'hint' => '',
              },
            ],
          },
        }
      end

      it 'returns the customs path' do
        expect(step.previous_step_path).to eq(customs_value_path)
      end
    end

    context 'when there are multiple measure type ids on the applicable_additional_codes hash' do
      let(:current_measure_type_id) { '552' }

      it 'returns additional_codes_path with the previous measure_type_id as argument' do
        expect(step.previous_step_path).to eq(additional_codes_path('105'))
      end
    end
  end

  describe '#next_step_path' do
    include Rails.application.routes.url_helpers

    context 'when there is just one measure type id on the applicable_additional_codes
    hash' do
      let(:additional_codes) do
        {
          '105' => {
            'heading' => {
              'overlay' => 'Describe your goods in more detail',
              'hint' => 'To trade this commodity, you need to specify an additional 4 digits, known as an additional code',
            },
            'additional_codes' => [
              {
                'code' => '2600',
                'overlay' => 'The product I am importing is COVID-19 critical',
                'hint' => "Read more about the <a target='_blank' href='https://www.gov.uk/government/news/hmg-suspends-import-tariffs-on-covid-19-products-to-fight-virus'>suspension of tariffs on COVID-19 critical goods [opens in a new browser window]</a>",
              },
              {
                'code' => '2601',
                'overlay' => 'The product I am importing is not COVID-19 critical',
                'hint' => '',
              },
            ],
          },
        }
      end

      it 'returns confirm_path' do
        expect(step.next_step_path).to eq(confirm_path)
      end
    end

    context 'when there are multiple measure type ids on the applicable_additional_codes hash' do
      it 'returns additional_codes_path with the next measure_type_id as argument' do
        expect(step.next_step_path).to eq(additional_codes_path('552'))
      end
    end
  end
end
