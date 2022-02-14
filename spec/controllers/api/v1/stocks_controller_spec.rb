# frozen_string_literal: ture
require "rails_helper"

describe Api::V1::StocksController do
  describe "GET index" do
    let(:first_stock) { create(:stock) }
    let(:second_stock) { create(:stock) }

    before do
      first_stock
      second_stock
    end

    context "when page param is passed" do
      it "renders paginated amount of stock records" do
        get :index, params: { page: 1, per_page: 1 }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["records"].count).to eq(1)
      end
    end

    context "when page param is not passed" do
      it "renders all stock records" do
        get :index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["records"].count).to eq(2)
      end
    end
  end

  describe "POST create" do
    let(:stock_name) { "stock_name" }

    context "with non-existing bearer" do
      let(:bearer_name) { "bearer_name" }

      context "when bearer and stock created without errors" do
        it "creates stock with a referenced bearer" do
          post :create, params: { stock: { name: stock_name, bearer_name: bearer_name } }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["name"]).to eq(stock_name)
          expect(JSON.parse(response.body)["error"]).to be_nil

          expect(Stock.count).to eq(1)
          expect(Bearer.count).to eq(1)

          stock = Stock.last

          expect(stock.name).to eq(stock_name)
          expect(stock.bearer.name).to eq(bearer_name)
        end
      end

      context "when there is an error during stock creation" do
        let(:existing_stock) { create(:stock, name: stock_name) }

        before do
          existing_stock
        end

        it "returns stock errors" do
          post :create, params: { stock: { name: stock_name, bearer_name: bearer_name } }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)["error"]).to eq("Stock - Validation failed: Name has already been taken")

          expect(Bearer.count).to eq(1)
          expect(Stock.count).to eq(1)
          expect(Stock.last.id).to eq(existing_stock.id)
          expect(Bearer.last.id).to eq(existing_stock.bearer.id)
        end
      end
    end

    context "with existing bearer" do
      let(:existing_bearer) { create(:bearer) }

      before do
        existing_bearer
      end

      it "uses existing bearer to create stock" do
        post :create, params: { stock: { name: stock_name, bearer_name: existing_bearer.name } }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq(stock_name)
        expect(JSON.parse(response.body)["error"]).to be_nil

        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(1)

        stock = Stock.last

        expect(stock.name).to eq(stock_name)
        expect(stock.bearer_id).to eq(existing_bearer.id)
        expect(stock.bearer.name).to eq(existing_bearer.name)
      end
    end
  end

  describe "PATCH update" do
    context "when rename to a uniq stock name" do
      let(:existing_stock) { create(:stock) }
      let(:uniq_name) { "uniq_name" }

      before do
        existing_stock
      end

      it "updates name of the stock" do
        expect(Stock.last.name).to eq(existing_stock.name)

        patch :update, params: { id: existing_stock.id, stock: { name: uniq_name } }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq(uniq_name)
        expect(JSON.parse(response.body)["error"]).to be_nil

        expect(Stock.last.name).to eq(uniq_name)
      end
    end

    context "when reassign to an existing bearer" do
      let(:existing_stock) { create(:stock) }
      let(:existing_bearer) { create(:bearer) }

      before do
        existing_stock
        existing_bearer
      end

      it "updates name of the stock" do
        expect(Stock.last.bearer.id).to eq(existing_stock.bearer.id)

        patch :update, params: { id: existing_stock.id, stock: { bearer_name: existing_bearer.name } }

        expect(response).to have_http_status(:ok)

        expect(Stock.last.bearer.id).to eq(existing_bearer.id)
      end
    end

    context "when there is an error during the update" do
      let(:first_existing_stock) { create(:stock) }
      let(:second_existing_stock) { create(:stock) }

      before do
        first_existing_stock
        second_existing_stock
      end

      it "updates name of the stock" do
        patch :update, params: { id: first_existing_stock.id, stock: { name: second_existing_stock.name } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("Stock - Validation failed: Name has already been taken")
      end
    end
  end

  describe "DELETE destroy" do
    let(:first_stock) { create(:stock) }
    let(:second_stock) { create(:stock) }

    before do
      first_stock
      second_stock
    end

    it "soft deletes stock" do
      get :index

      expect(JSON.parse(response.body)["records"].count).to eq(2)

      delete :destroy, params: { id: first_stock.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["discarded_at"]).to be_present

      get :index

      expect(JSON.parse(response.body)["records"].count).to eq(1)
      expect(JSON.parse(response.body)["records"].first["name"]).to eq(second_stock.name)
    end
  end
end
