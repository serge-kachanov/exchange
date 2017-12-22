# frozen_string_literal: true

require 'rails_helper'

describe ExchangeRate, type: :model do
  let!(:exchange_rates)  { FactoryBot.create_list(:exchange_rate, 10) }
  let(:exchange_rate) { exchange_rates.first }


  describe 'validations' do
    it { is_expected.to validate_presence_of(:rate) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_uniqueness_of(:date) }
    it { is_expected.to validate_numericality_of(:rate) }
  end

  describe '.find_rate' do
    it 'should find exchange_rate by provided date' do
      expect(described_class.find_rate(exchange_rate.date)).to eql exchange_rate
    end

    context 'should find first exchange_rate' do
      before { exchange_rate }
      
      it 'by empty date' do
        expect(described_class.find_rate('')).to eql exchange_rate
      end

      it 'by dummy date' do
        expect(described_class.find_rate(Time.zone.now - 100.years)).to eql nil
      end
    end
  end

  describe '.convert' do
    it 'should convert provided amount with provided rate' do
      ExchangeRate.convert(2,2).should == 4
    end
  end
end
