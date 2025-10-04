require 'bunny'
require 'json'

class OrderCreatedConsumer
  def initialize
    @connection = Bunny.new(ENV.fetch('RABBITMQ_URL', 'amqp://guest:guest@localhost:5672'))
    @connection.start
    @channel = @connection.create_channel
    @exchange = @channel.topic('orders.exchange', durable: true)
    @queue = @channel.queue('customer.orders.queue', durable: true)
    @queue.bind(@exchange, routing_key: 'order.created')
  end

  def handle_message(body)
    payload = JSON.parse(body)
    order_data = payload['order'] || {}
    customer_id = order_data['customer_id']
    return unless customer_id

    customer = Customer.find_by(id: customer_id)
    if customer
      customer.increment!(:orders_count)
    else
      Rails.logger.warn("Customer \#{customer_id} not found while processing order event")
    end
  end

  def start
    @queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
      begin
        handle_message(body)
        @channel.ack(delivery_info.delivery_tag)
      rescue => e
        Rails.logger.error("Error processing order.created: \#{e.message}")
        @channel.nack(delivery_info.delivery_tag, false, true)
      end
    end
  end
end
