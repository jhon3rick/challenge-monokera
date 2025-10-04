class CustomersController < ApplicationController
  # GET /customers
  def index
    customers = Customer.all
    render json: {
      data: customers.as_json(only: [:id, :customer_name, :address, :orders_count])
    }
  end

  # GET /customers/:id
  def show
    customer = Customer.find(params[:id])
    render json: {
      data: {
        customer_name: customer.customer_name,
        address: customer.address,
        orders_count: customer.orders_count
      }
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Customer not found' }, status: :not_found
  end
end