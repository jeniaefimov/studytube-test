# frozen_string_literal: true

module Api
  module V1
    class StocksController < ApplicationController
      def index
        stocks = Stock.kept.includes(:bearer).all

        render json: PaginationWrapper
                       .new(stocks, StockSerializer)
                       .page(params[:page])
                       .per(params[:per_page])
                       .result
                       .to_json, status: :ok
      end

      def create
        ActiveRecord::Base.transaction do
          bearer = Bearer.find_or_create_by!(name: stock_params[:bearer_name])

          @stock = Stock.create!(name: stock_params[:name], bearer_id: bearer.id)
        end

        render json: @stock, serializer: StockSerializer, status: :ok

      rescue ActiveRecord::RecordInvalid => exception
        render json: { error: "#{exception.record.class.to_s} - #{exception.message}" }, status: :unprocessable_entity
      end

      def update
        ActiveRecord::Base.transaction do
          update_attributes = {}

          bearer = Bearer.find_or_create_by!(name: stock_params[:bearer_name]) if stock_params[:bearer_name].present?

          update_attributes.merge!(bearer_id: bearer.id) if bearer.present?
          update_attributes.merge!(name: stock_params[:name]) if stock_params[:name].present?

          find_stock.update!(update_attributes)
        end

        render json: find_stock, serializer: StockSerializer, status: :ok

      rescue ActiveRecord::RecordInvalid => exception
        render json: { error: "#{exception.record.class.to_s} - #{exception.message}" }, status: :unprocessable_entity
      end

      def destroy
        if find_stock.discard
          render json: find_stock, serializer: StockSerializer, status: :ok
        else
          render json: { errors: stock.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def find_stock
        @_stock ||= Stock.find(params[:id])
      end

      def stock_params
        params.require(:stock).permit(:name, :bearer_name)
      end
    end
  end
end
