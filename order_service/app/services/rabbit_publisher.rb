require 'bunny'

class RabbitPublisher
  def self.connection
    @connection ||= Bunny.new(ENV.fetch('RABBITMQ_URL', 'amqp://guest:guest@localhost:5672')).tap(&:start)
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.exchange
    @exchange ||= channel.topic('orders.exchange', durable: true)
  end

  def self.publish(routing_key, payload)
    exchange.publish(payload.to_json, routing_key: routing_key, persistent: true)
  end
end
