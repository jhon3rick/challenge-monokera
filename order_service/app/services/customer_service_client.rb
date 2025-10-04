require 'httparty'

class CustomerServiceClient
  include HTTParty
  base_uri ENV.fetch('CUSTOMER_SERVICE_URL', 'http://customer_service:3001')

  # Devuelve un hash con keys: customer_name, address, orders_count
  def self.fetch(customer_id)
    response = get("/customers/#{customer_id}")
    raise "CustomerService error: #{response.code}" unless response.success?
    response.parsed_response
  end
end
