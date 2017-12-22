class CsvProcessorService
  require 'csv'
  require 'open-uri'

  URL = 'https://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'.freeze

  class << self
     def fetch_exchange_rates
       file = upload_file
       csv = parse_file(file)
       create_exchange_rates(csv)
     end

     def upload_file
       open(URL).read
     end

     def parse_file(file)
       CSV.parse(file, headers: false)
     end

     def create_exchange_rates(csv)
       rates = csv.map do |row|
         { date: row.first, rate: row.last.to_f }
       end
       ExchangeRate.bulk_insert(rates, validate: true)
     end
   end
end
