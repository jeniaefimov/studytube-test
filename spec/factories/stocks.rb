# frozen_string_literal: true

FactoryBot.define do
  factory :stock do
    name { FFaker::Name.unique.name }
    bearer
  end
end
