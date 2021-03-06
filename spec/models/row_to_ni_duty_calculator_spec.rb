RSpec.describe RowToNiDutyCalculator do
  subject(:calculator) { described_class.new(user_session, uk_options, xi_options) }

  let(:user_session) do
    build(
      :user_session,
      :with_commodity_information,
      :with_import_date,
      :with_import_destination,
      :with_country_of_origin,
      :with_trader_scheme,
      :with_certificate_of_origin,
      :with_customs_value,
      :with_measure_amount,
      :with_vat,
    )
  end

  before do
    allow(DutyOptions::Chooser).to receive(:new).and_call_original
  end

  it_behaves_like 'a duty calculator', category: :tariff_preference
  it_behaves_like 'a duty calculator', category: :suspension
  it_behaves_like 'a duty calculator', category: :quota

  describe '#option' do
    let(:unhandled_option) do
      build(
        :duty_option_result,
        :unhandled,
      )
    end

    context 'when there are unhandled options' do
      let(:uk_options) do
        OptionCollection.new(
          [
            unhandled_option,
          ],
        )
      end
      let(:xi_options) do
        OptionCollection.new(
          [
            unhandled_option,
          ],
        )
      end

      it 'returns an empty OptionCollection' do
        expect(calculator.options.to_a).to eq([])
      end
    end
  end
end
