class ExchangeRatesController < ApplicationController
  require 'csv'
  require 'open-uri'

  URL = 'https://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'.freeze

  def index
    exchange(params)
  end

  def fetch_exchange_rates
    file = upload_file
    csv = parse_file(file)
    create_exchange_rates(csv)
    redirect_to :root
  end

  private

    def exchange(params)
      @amount = 100
      @start_date, @end_date = ExchangeRate.last.date, ExchangeRate.first.date
      if params[:amount] && params[:date]
        @amount, @date = params[:amount].to_i, params[:date]
        exchange_rate = ExchangeRate.find_by(date: @date)
        @result = exchange_rate.rate * @amount
      else
        exchange_rate = ExchangeRate.first
        @result = exchange_rate.rate * @amount
        @date = exchange_rate.date
      end
    end

    def upload_file
      open(URL).read
    end

    def parse_file(file)
      CSV.parse(file, headers: false)
    end

    def create_exchange_rates(csv)
      csv.each { |row| ExchangeRate.create(date: row.first, rate: row.last) }
    end

end
