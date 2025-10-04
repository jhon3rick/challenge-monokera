# == Schema Information
#
# Table name: customers
#
#  id            :bigint           not null, primary key
#  customer_name :string           not null
#  address       :string
#  orders_count  :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Customer < ApplicationRecord
  validates :customer_name, presence: true
end
