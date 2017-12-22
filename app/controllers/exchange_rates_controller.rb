class ExchangeRatesController < ApplicationController
  before_action :set_defaults, only: :index

  def index
    @exchange_rate = ExchangeRate.find_rate(permitted_params[:date])
    if @exchange_rate
      @summ = ExchangeRate.convert(@exchange_rate.rate, @amount)
    end
  end

  def fetch_exchange_rates
    CsvProcessorService.fetch_exchange_rates
    redirect_to :root
  end

  private

  def permitted_params
    params.permit(:amount, :date)
  end

  def set_defaults
    permitted_params[:amount] ? @amount = permitted_params[:amount].to_f : @amount = 100
  end
end
