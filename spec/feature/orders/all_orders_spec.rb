require 'rails_helper'

feature 'View all order and details' do
  let(:customer) { create :customer, :admin }

  let(:customer_one) { create :customer }
  let!(:product_one) { create :product }
  let!(:order_one) { create :order, customer: customer_one }
  let!(:order_item_one) { create :order_item, order: order_one, product: product_one }

  let(:customer_two) { create :customer }
  let!(:product_two) { create :product }
  let!(:order_two) { create :order, :paid, customer: customer_two }
  let!(:order_item_two) { create :order_item, order: order_two, product: product_two }

  before do
    sign_in customer
    visit all_orders_path
  end

  it do
    expect(page).to have_content(customer_one.name)
    expect(page).to have_content(product_one.name)
    expect(page).to have_content(order_one.status)

    expect(page).to have_content(customer_two.name)
    expect(page).to have_content(product_two.name)
    expect(page).to have_content(order_two.status)
  end

  context 'customer role' do
    let(:customer) { create :customer }

    it do
      expect(page).to have_content('You are not authorised to view this page')
    end
  end
end
