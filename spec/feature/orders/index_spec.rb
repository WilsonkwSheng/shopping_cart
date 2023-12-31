require 'rails_helper'

feature 'List of orders and details' do
  let(:customer) { create :customer }
  let!(:product_one) { create :product }
  let!(:pending_order) { create :order, customer: customer }
  let!(:pending_order_item) { create :order_item, order: pending_order, product: product_one }

  let!(:product_two) { create :product }
  let!(:paid_order) { create :order, :paid, customer: customer }
  let!(:paid_order_item) { create :order_item, order: paid_order, product: product_two }

  before do
    sign_in customer
    visit orders_path
  end

  it do
    expect(page).to have_content(product_one.name)
    expect(page).to have_content(product_two.name)
  end
end
