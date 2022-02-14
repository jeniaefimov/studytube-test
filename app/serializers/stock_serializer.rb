# frozen_string_literal: true
class StockSerializer < ActiveModel::Serializer
  attributes :id, :name, :discarded_at, :created_at, :updated_at

  belongs_to :bearer
end
