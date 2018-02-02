require 'rspec'
require 'sequel'
require_relative '../db/connection'
require_relative '../services/exchange_service'
require_relative '../db/models/exchange_rate'
require 'bigdecimal'
require 'date'
require_relative '../services/downloader_service'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

RSpec.describe DownloaderService do

  describe '#populate_db' do
    before(:all) do
      ExchangeRate.dataset.delete
    end

    it 'should populate database' do
      VCR.use_cassette('CSVcassette') do
        expect(ExchangeRate.dataset.count).to eq(0)
        expect { described_class.populate_db }.to(change { ExchangeRate.dataset.count })
      end
    end
  end
end