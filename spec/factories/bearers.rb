# frozen_string_literal: true

FactoryBot.define do
  factory :bearer do
    name { FFaker::Name.unique.name }
  end
end
