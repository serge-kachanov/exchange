# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_rate do
    rate { Faker::Number.decimal(2) }
    sequence(:date) { |n| Faker::Date.between(100.years.from_now, Time.zone.today + n.days) }
  end
end
