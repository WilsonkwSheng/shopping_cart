class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true
  validates :status, inclusion: { in: ['pending', 'paid'], message: "%{value} is not a valid status" }, if: -> { status.present? }
end
