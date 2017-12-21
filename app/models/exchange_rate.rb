class ExchangeRate < ApplicationRecord
  validates_presence_of :rate, :date
  validates_uniqueness_of :date
  validates_numericality_of :rate
end
