require 'spec_helper'
require 'csv_processor_service'

describe CsvProcessorService, type: :service do
  describe '.upload_file' do
    it 'should return file' do
      expect_any_instance_of(Tempfile).to receive(:read).and_return 'fake_file'
      described_class.upload_file
    end
  end

  describe '.parse_file' do
    it 'should parse CSV file' do
      file = File.open('./spec/fixtures/sample.csv').read
      expect(described_class.parse_file(file).count).to eql 5
    end
  end

  describe '.create_exchange_rates' do
    it 'should fill database from array' do
      array = [["2019-12-21","1,1839"], ["2020-12-20", "1,1859"]]
      expect { described_class.create_exchange_rates(array) } .to change { ExchangeRate.count } .by 2
    end
  end
end
