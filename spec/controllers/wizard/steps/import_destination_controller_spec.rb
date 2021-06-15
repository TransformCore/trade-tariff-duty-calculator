RSpec.describe Wizard::Steps::ImportDestinationController do
  before do
    allow(UserSession).to receive(:new).and_return(session)
  end

  let(:session) { build(:user_session, :with_commodity_information) }

  describe 'GET #show' do
    subject(:response) { get :show }

    it 'assigns the correct step' do
      response
      expect(assigns[:step]).to be_a(Wizard::Steps::ImportDestination)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response).to render_template('import_destination/show') }
  end

  describe 'POST #create' do
    subject(:response) { post :create, params: answers }

    let(:answers) do
      {
        wizard_steps_import_destination: {
          import_destination: import_destination,
        },
      }
    end

    context 'when the step answers are valid' do
      let(:import_destination) { 'GB' }

      it 'assigns the correct step' do
        response
        expect(assigns[:step]).to be_a(Wizard::Steps::ImportDestination)
      end

      it { expect(response).to redirect_to(country_of_origin_path) }
      it { expect { response }.to change(session, :import_destination).from(nil).to('GB') }
    end

    context 'when the step answers are invalid' do
      let(:import_destination) { '' }

      it 'assigns the correct step' do
        response
        expect(assigns[:step]).to be_a(Wizard::Steps::ImportDestination)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template('import_destination/show') }
      it { expect { response }.not_to change(session, :import_destination).from(nil) }
    end
  end
end
