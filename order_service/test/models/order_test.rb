require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @valid_attributes = {
      customer_id: 1,
      product_name: "Premium Widget",
      quantity: 2,
      price: 29.99
    }
  end

  test "should be valid with all required attributes" do
    order = Order.new(@valid_attributes)
    assert_predicate order, :valid?
  end

  test "should require customer_id" do
    order = Order.new(@valid_attributes.except(:customer_id))
    assert_not order.valid?
    assert_includes order.errors[:customer_id], "can't be blank"
  end

  test "should require product_name" do
    order = Order.new(@valid_attributes.except(:product_name))
    assert_not order.valid?
    assert_includes order.errors[:product_name], "can't be blank"
  end

  test "should require quantity" do
    order = Order.new(@valid_attributes.except(:quantity))
    assert_not order.valid?
    assert_includes order.errors[:quantity], "can't be blank"
  end

  test "should require price" do
    order = Order.new(@valid_attributes.except(:price))
    assert_not order.valid?
    assert_includes order.errors[:price], "can't be blank"
  end

  test "quantity should be greater than 0" do
    order = Order.new(@valid_attributes.merge(quantity: 0))
    assert_not order.valid?
    assert_includes order.errors[:quantity], "must be greater than 0"
  end

  test "price should be greater than or equal to 0" do
    order = Order.new(@valid_attributes.merge(price: -1))
    assert_not order.valid?
    assert_includes order.errors[:price], "must be greater than or equal to 0"
  end

  test "should not publish event when save fails" do
    RabbitPublisher.expects(:publish).never
    
    order = Order.new(@valid_attributes.merge(quantity: -1)) # Invalid quantity
    
    assert_no_difference('Order.count') do
      assert_raises(ActiveRecord::RecordInvalid) { order.save! }
    end
  end
end
