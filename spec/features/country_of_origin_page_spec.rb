require 'rails_helper'

RSpec.describe 'Country of Origin Page', type: :feature do
  let(:commodity_code) { '1234567890' }
  let(:service_choice) { 'uk' }
  let(:import_into) { 'GB' }

  before do
    visit import_date_path(commodity_code: commodity_code, service_choice: service_choice)

    fill_in('wizard_steps_import_date[import_date(3i)]', with: '12')
    fill_in('wizard_steps_import_date[import_date(2i)]', with: '12')
    fill_in('wizard_steps_import_date[import_date(1i)]', with: '2030')

    click_on('Continue')

    choose(option: import_into)

    click_on('Continue')
  end

  it 'does not store an empty geographical area id on the session' do
    click_on('Continue')

    expect(Capybara.current_session.driver.request.session.key?(Wizard::Steps::CountryOfOrigin::STEP_ID)).to be false
  end

  it 'does store the country of origin date on the session' do
    select('United Kingdom (Northern Ireland)', from: 'wizard_steps_country_of_origin[geographical_area_id]')

    click_on('Continue')

    expect(Capybara.current_session.driver.request.session[Wizard::Steps::CountryOfOrigin::STEP_ID]).to eq('XI')
  end

  it 'loses its session key when going back to the previous question' do
    select('United Kingdom (Northern Ireland)', from: 'wizard_steps_country_of_origin[geographical_area_id]')

    click_on('Continue')

    click_on('Back')
    click_on('Back')

    expect(Capybara.current_session.driver.request.session.key?(Wizard::Steps::CountryOfOrigin::STEP_ID)).to be false
  end

  context 'when importing from NI to GB' do
    it 'redirects to duty path' do
      select('United Kingdom (Northern Ireland)', from: 'wizard_steps_country_of_origin[geographical_area_id]')

      click_on('Continue')

      expect(page).to have_current_path(duty_path(service_choice: service_choice, commodity_code: commodity_code))
    end
  end
end
