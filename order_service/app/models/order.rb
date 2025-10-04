# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  customer_id      :integer          not null
#  product_name     :string           not null
#  quantity         :integer          not null
#  price            :decimal(12, 2)   not null
#  status           :string           default("pending")
#  customer_name    :string
#  customer_address :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Order < ApplicationRecord
  # validations
  validates :customer_id, :product_name, :quantity, :price, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :publish_created_event

  private

  def publish_created_event
    RabbitPublisher.publish('order.created', order: as_json)
  rescue => e
    Rails.logger.error("Failed to publish order event: \#{e.message}")
  end
end
