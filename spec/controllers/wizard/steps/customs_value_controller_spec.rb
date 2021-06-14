RSpec.describe Wizard::Steps::CustomsValueController do
  before do
    allow(UserSession).to receive(:new).and_return(session)
  end

  let(:session) { build(:user_session, :with_commodity_information) }

  describe 'GET #show' do
    subject(:response) { get :show }

    it 'assigns the correct step' do
      response
      expect(assigns[:step]).to be_a(Wizard::Steps::CustomsValue)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response).to render_template('customs_value/show') }
  end

  describe 'POST #create' do
    subject(:response) { post :create, params: answers }

    let(:answers) do
      {
        wizard_steps_customs_value: customs_value,
      }
    end

    context 'when the step answers are valid' do
      let(:customs_value) { attributes_for(:customs_value, monetary_value: '1500') }

      it 'assigns the correct step' do
        response
        expect(assigns[:step]).to be_a(Wizard::Steps::CustomsValue)
      end

      it { expect(response).to redirect_to(measure_amount_path) }
      it { expect { response }.to change(session, :monetary_value).from(nil).to('1500') }
    end

    context 'when the step answers are invalid' do
      let(:customs_value) { attributes_for(:customs_value, monetary_value: '-1500') }

      it 'assigns the correct step' do
        response
        expect(assigns[:step]).to be_a(Wizard::Steps::CustomsValue)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template('customs_value/show') }
      it { expect { response }.not_to change(session, :customs_value).from(nil) }
    end
  end
end
