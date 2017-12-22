class ExchangeRate < ApplicationRecord
  validates :rate, :date, presence: true
  validates :date, uniqueness: true
  validates :rate, numericality: true

  private
    class << self
      def find_rate(date)
        date.present? ? find_by(date: date) : first
      end

      def convert(rate, amount)
        rate * amount
      end
    end
end
