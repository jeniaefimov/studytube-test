# frozen_string_literal: true
require "rails_helper"

describe PaginationWrapper do
  class SomeSerializer < ActiveModel::Serializer
  end

  let(:relation) { Stock.all }

  describe "#initialize" do
    it "raise an ArgumentError" do
      expect { described_class.new([1, 2, 3], SomeSerializer) }.to raise_error(ArgumentError)
    end
  end

  describe "#page and #per" do
    it "return page with correct size" do
      result = described_class.new(relation, SomeSerializer).page(1).per(1).result
      expect(result[:records]).not_to be_nil
      expect(result[:total_pages]).to be(0)
      expect(result[:current_page]).to be(1)
    end
  end
end
