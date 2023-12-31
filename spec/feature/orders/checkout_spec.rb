require 'rails_helper'

feature 'Checkout ongoing pending order' do
  let(:customer) { create :customer }
  let!(:product) { create :product }
  let!(:order) { create :order, customer: customer }
  let!(:order_item) { create :order_item, order: order, product: product }

  before do
    sign_in customer
    visit orders_path
  end

  it do
    click_on 'Checkout 1 items'

    expect(page).to have_content('Order was successfully paid.')
    expect(order.reload.status).to eq('paid')
  end
end
