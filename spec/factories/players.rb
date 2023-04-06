# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    id { SecureRandom.random_number(1000000..9999999).to_s }
    firstname { 'Patrick' }
    lastname { 'Mahomes' }
    position { 'QB' }
    sport { :football }
    age { 26 }
  end
end
