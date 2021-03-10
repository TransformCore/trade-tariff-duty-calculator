require 'rails_helper'

RSpec.describe Api::Commodity, type: :model do
  subject(:commodity) { described_class.build(service, commodity_code) }

  let(:commodity_code) { '0702000007' }
  let(:service) { :uk }

  before do
    allow(Uktt::Commodity).to receive(:new).and_call_original
  end

  describe '.resource_key' do
    it 'returns the correct resource key' do
      expect(described_class.resource_key).to eq(:commodity_id)
    end
  end

  describe '#description' do
    it 'returns the expected description' do
      expect(commodity.description).to eq('Cherry Tomatoes')
    end

    it 'returns a safe html description' do
      expect(commodity.description).to be_html_safe
    end
  end

  describe '#code' do
    it 'returns the goods_nomenclature_item_id' do
      expect(commodity.code).to eq(commodity.goods_nomenclature_item_id)
    end
  end

  describe '#import_measures' do
    it 'returns a list of measures' do
      all_are_measures = commodity.import_measures.all? { |resource| resource.is_a?(Api::Measure) }

      expect(all_are_measures).to be(true)
    end
  end

  describe '#export_measures' do
    it 'returns a list of measures' do
      all_are_measures = commodity.export_measures.all? { |resource| resource.is_a?(Api::Measure) }

      expect(all_are_measures).to be(true)
    end
  end

  describe '#zero_mfn_duty' do
    it 'returns false' do
      expect(commodity.zero_mfn_duty).to be(false)
    end
  end

  describe '#trade_defence' do
    it 'returns true' do
      expect(commodity.trade_defence).to be(true)
    end
  end

  describe '#applicable_measure_units' do
    let(:expected_units) do
      {
        'DTN' => {
          'measurement_unit_code' => 'DTN',
          'measurement_unit_qualifier_code' => '',
          'abbreviation' => '100 kg',
          'unit_question' => 'What is the weight of the goods you will be importing?',
          'unit_hint' => 'Enter the value in decitonnes (100kg)',
          'unit' => 'x 100 kg',
          'measure_sids' => [
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
        },
      }
    end

    it 'returns the expected units' do
      expect(commodity.applicable_measure_units).to eq(expected_units)
    end
  end
end
