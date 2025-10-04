class OrdersController < ApplicationController

  # GET /orders
  def index
    if params[:customer_id].present?
      orders = Order.where(customer_id: params[:customer_id])
    else
      orders = Order.all
    end

    render json: {
      data: orders.as_json(only: [:id, :customer_id, :product_name, :quantity, :price, :status])
    }
  end

  # POST /orders
  def create
    customer_id = order_params[:customer_id].to_i
    return render json: { error: 'customer_id must be a positive integerdsa' }, status: :unprocessable_entity if customer_id <= 0

    customer_data = CustomerServiceClient.fetch(customer_id)

    order = Order.new(order_params)
    order.customer_name = customer_data.dig('data', 'customer_name')
    order.customer_address = customer_data.dig('data', 'address')

    if order.save
      render json: { data: order }, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :bad_gateway
  end

  private

  def order_params
    params.permit(:customer_id, :product_name, :quantity, :price, :status)
  end
end
