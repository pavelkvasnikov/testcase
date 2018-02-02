require 'csv'
require 'open-uri'
require 'sequel'
require_relative '../db/connection'
require_relative './../db/models/exchange_rate'

class DownloaderService
  CSV_LINK = 'https://sdw.ecb.europa.eu/quickviewexport.do;jsessionid=6B0E2A6E93BA1C8CDA0E20C369D46F4E?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'.freeze
  START_ROW = 5

  def self.populate_db
    file_raw = open(CSV_LINK)
    file_parsed = CSV.read(file_raw)[START_ROW..-1]
    data = file_parsed.each_slice(900).to_a # SQLite bulk insert problem limit is 1000
    data.each do |portion|
      ExchangeRate.import(%i[created_at price], portion)
    end
  end
end
