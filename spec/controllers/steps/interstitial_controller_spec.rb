RSpec.describe Steps::InterstitialController do
  before do
    allow(UserSession).to receive(:new).and_return(session)
  end

  let(:session) { build(:user_session, :with_commodity_information) }

  describe 'GET #show' do
    subject(:response) { get :show }

    it 'assigns the correct step' do
      response
      expect(assigns[:step]).to be_a(Steps::Interstitial)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response).to render_template('interstitial/show') }
  end
end
