require 'spec_helper'

describe TariffRate::OmanData do
  fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/oman"
  fixtures_file = "#{fixtures_dir}/oman.csv"

  s3 = stubbed_s3_client('tariff_rate')
  s3.stub_responses(:get_object, body: open(fixtures_file))

  let(:importer) { described_class.new(fixtures_file, s3) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads OMAN tariff rates from specified resource' do
      expect(TariffRate::Oman).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end