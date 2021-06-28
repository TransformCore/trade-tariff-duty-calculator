RSpec.describe Wizard::Steps::MeasureAmountController do
  before do
    allow(UserSession).to receive(:new).and_return(session)
    allow(Wizard::Steps::MeasureAmount).to receive(:new).and_call_original
  end

  let(:session) { build(:user_session, :with_commodity_information) }

  let(:expected_applicable_measure_units) do
    {
      'applicable_measure_units' =>
      {
        'DTN' =>
          {
            'abbreviation' => '100 kg',
            'measure_sids' =>
              [
                20_005_920,
                20_056_507,
                20_073_335,
                20_076_779,
                20_090_066,
                20_105_690,
                20_078_066,
                20_102_998,
                20_108_866,
                20_085_014,
              ],
            'measurement_unit_code' => 'DTN',
            'measurement_unit_qualifier_code' => '',
            'unit' => 'x 100 kg',
            'unit_hint' => 'Enter the value in decitonnes (100kg)',
            'unit_question' =>
              'What is the weight of the goods you will be importing?',
          },
      },
      'measure_amount' => {},
    }
  end

  describe 'GET #show' do
    subject(:response) { get :show }

    it 'assigns the correct step' do
      response
      expect(assigns[:step]).to be_a(Wizard::Steps::MeasureAmount)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response).to render_template('measure_amount/show') }

    it 'passes the correct params to the Wizard::Steps::MeasureAmount step' do
      response

      expect(Wizard::Steps::MeasureAmount).to have_received(:new).with(
        session, expected_applicable_measure_units
      )
    end

    context 'when deltas_applicable' do
      let(:session) { build(:user_session, :with_commodity_information, :deltas_applicable) }

      it 'passes the correct params to the Wizard::Steps::MeasureAmount step' do
        response

        expect(Wizard::Steps::MeasureAmount).to have_received(:new).with(
          session, expected_applicable_measure_units
        )
      end
    end
  end

  describe 'POST #create' do
    subject(:response) { post :create, params: answers }

    let(:answers) do
      {
        wizard_steps_measure_amount: measure_amount,
      }
    end

    context 'when the step answers are valid' do
      let(:measure_amount) do
        {
          'dtn' => 100,
        }
      end

      it 'assigns the correct step' do
        response
        expect(assigns[:step]).to be_a(Wizard::Steps::MeasureAmount)
      end

      it { expect(response).to redirect_to(additional_codes_path('105')) }
      it { expect { response }.to change(session, :measure_amount).from({}).to('dtn' => '100') }
    end

    context 'when the step answers are invalid' do
      let(:measure_amount) { attributes_for(:measure_amount, measure_amount: '') }

      it 'assigns the correct step' do
        response
        expect(assigns[:step]).to be_a(Wizard::Steps::MeasureAmount)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template('measure_amount/show') }
      it { expect { response }.not_to change(session, :measure_amount).from({}) }
    end
  end
end
