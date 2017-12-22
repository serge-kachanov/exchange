require 'spec_helper'

describe ExchangeRatesController, type: :controller do

  describe '#index' do
    let!(:exchange_rates) { FactoryBot.create_list(:exchange_rate, 10) }

    context 'should return default values if no params provided' do
      subject(:request) { get :index }

      before { request }

      it { expect(assigns(:amount)).to eql 100 }
      it { expect(assigns(:exchange_rate)).to eql exchange_rates.first }
      it { expect(assigns(:summ)).not_to be_nil }
      it { expect(response.status).to eql 200 }
      it { expect(request).to render_template('index') }
    end

    context 'should return relevant data if params provided' do
      subject(:request) { get :index, params: provided_params }

      let(:provided_amount) { 50 }
      let(:exchange_rate) { exchange_rates.fifth }
      let(:rate) { exchange_rate.rate }
      let(:provided_date) { exchange_rate.date }
      let(:provided_params) { { date: provided_date, amount: provided_amount } }

      before do |example|
        request unless example.metadata[:escape]
      end

      it { expect(assigns(:amount)).to eql provided_amount.to_f }
      it { expect(assigns(:exchange_rate)).to eql exchange_rate }
      it { expect(assigns(:summ)).to eql ExchangeRate.convert(rate, provided_amount) }
      it { expect(response.status).to eql 200 }
      it 'should render_template index', escape: true do
        expect(request).to render_template('index')
      end
    end
  end

  describe '#fetch_exchange_rates' do
    subject(:request) { get :fetch_exchange_rates }

    before do |example|
      unless example.metadata[:escape]
        allow(CsvProcessorService).to receive(:fetch_exchange_rates).and_return true
        request
      end
    end

    it { expect(response.status).to eql 302 }
    it { expect(request).to redirect_to(:root) }
    it 'checks CsvProcessorService.fetch_exchange_rates', escape: true do
      expect(CsvProcessorService).to receive(:fetch_exchange_rates).and_return(true)
      request
    end
  end
end
