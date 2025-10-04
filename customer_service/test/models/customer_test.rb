require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "debe guardar un cliente válido" do
    customer = Customer.new(customer_name: "Cliente de Prueba", address: "Dirección 123")
    assert customer.save, "No se pudo guardar el cliente con atributos válidos"
  end

  test "no debe guardar un cliente sin nombre" do
    customer = Customer.new(address: "Dirección sin nombre")
    assert_not customer.save, "Se guardó un cliente sin nombre"
  end

  test "debe tener un contador de pedidos por defecto en 0" do
    customer = Customer.new(customer_name: "Cliente con contador")
    customer.save
    assert_equal 0, customer.orders_count, "El contador de pedidos no se inicializó en 0"
  end
end
