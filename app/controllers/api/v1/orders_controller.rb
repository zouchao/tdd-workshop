class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!
  def show
    render json: OrderSerializer.new(current_user.orders.find params[:id])
  end

  def index
    render json: OrderSerializer.new(current_user.orders)
  end

  def create
    order = current_user.orders.build order_params
    if order.save
      render json: OrderSerializer.new(order), status: 201
    else
      render json: { errors: ErrorSerializer.new(order).serialized_json }, status: 422
    end
  end

  private

    def order_params
      params.require(:order).permit(toy_ids: [])
    end
end
