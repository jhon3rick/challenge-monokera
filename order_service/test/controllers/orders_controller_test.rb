require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_id = 1
    @order_attributes = {
      customer_id: @customer_id,
      product_name: "Test Product",
      quantity: 2,
      price: 9.99,
      status: "pending"
    }
    @customer_data = {
      'data' => {
        'customer_name' => 'John Doe',
        'address' => '123 Test St'
      }
    }
  end

  test "should get index" do
    Order.create!(@order_attributes)
    get orders_url, as: :json
    assert_response :success
    assert_not_nil JSON.parse(response.body)['data']
  end

  test "should filter orders by customer_id when provided" do
    customer_id = 123456
    Order.insert_all([
      @order_attributes.merge(customer_id: customer_id),
      @order_attributes.merge(customer_id: customer_id+1)
    ])
    
    get orders_url(customer_id: customer_id)
    
    orders = JSON.parse(response.body)['data']
    assert_equal 1, orders.length
    assert_equal customer_id, orders.first['customer_id']
  end

  test "should create order with valid parameters" do
    # Mock de la respuesta del servicio de clientes
    CustomerServiceClient.stubs(:fetch).with(@customer_id).returns(@customer_data)
    
    # Mock para RabbitPublisher
    RabbitPublisher.stubs(:publish)

    assert_difference('Order.count', 1) do
      post orders_url, params: @order_attributes, as: :json
    end

    assert_response :created
    order = JSON.parse(response.body)['data']
    assert_equal @order_attributes[:product_name], order['product_name']
    assert_equal @order_attributes[:quantity], order['quantity']
    assert_equal @order_attributes[:price].to_s, order['price'].to_s
    assert_equal @customer_data['data']['customer_name'], order['customer_name']
    assert_equal @customer_data['data']['address'], order['customer_address']
  end

  test "should not create order with invalid parameters" do
    # Mock de la respuesta del servicio de clientes
    CustomerServiceClient.stubs(:fetch).with(@customer_id).returns(@customer_data)
    
    # Mock para RabbitPublisher
    RabbitPublisher.stubs(:publish)

    assert_no_difference('Order.count', 0) do
      post orders_url, params: {**@order_attributes, customer_id: ''}, as: :json
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "customer_id must be a positive integer"
  end

  test "should handle customer service error" do
    # Mock para simular un error en el servicio de clientes
    CustomerServiceClient.define_singleton_method(:fetch) do |customer_id|
      raise StandardError, 'Customer service error'
    end

    post orders_url, params: { order: {**@order_attributes, customer_id: '46578946456564'} }, as: :json

    assert_response :unprocessable_entity
    assert_includes response.body, 'customer_id must be a positive integer'
  ensure
    # Limpiar el método mock después de la prueba
    CustomerServiceClient.singleton_class.undef_method(:fetch) if CustomerServiceClient.respond_to?(:fetch)
  end

  test "should not include sensitive data in JSON response" do
    Order.create!(@order_attributes)
    get orders_url, as: :json
    
    order = JSON.parse(response.body)['data'].first
    assert_nil order['created_at']
    assert_nil order['updated_at']
  end
end
