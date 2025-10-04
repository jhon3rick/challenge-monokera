require 'test_helper'

class CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer1 = Customer.create!(customer_name: "Primer Cliente", address: "Dirección 123")
    @customer2 = Customer.create!(customer_name: "Segundo Cliente", address: "Otra dirección")
  end

  test "debe obtener listado de clientes" do
    get customers_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_not_nil json_response['data']
    assert_equal 2, json_response['data'].size
  end

  test "debe mostrar un cliente existente" do
    get customer_url(@customer1), as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @customer1.customer_name, json_response['data']['customer_name']
    assert_equal @customer1.address, json_response['data']['address']
    assert_equal @customer1.orders_count, json_response['data']['orders_count']
  end

  test "debe devolver error 404 para un cliente inexistente" do
    get customer_url(id: 'no-existe'), as: :json
    assert_response :not_found
    
    json_response = JSON.parse(response.body)
    assert_equal 'Customer not found', json_response['error']
  end
end
