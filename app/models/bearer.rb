class Bearer < ApplicationRecord
  has_many :stocks

  validates_presence_of :name
  validates_uniqueness_of :name
end
