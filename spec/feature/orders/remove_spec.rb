require 'rails_helper'

feature 'Remove a product from ongoing pending order' do
  let(:customer) { create :customer }
  let!(:product) { create :product }
  let!(:order) { create :order, customer: customer }
  let!(:order_item) { create :order_item, order: order, product: product }

  before do
    sign_in customer
    visit orders_path
  end

  it do
    click_on 'Remove'

    expect(page).to have_content('Product was successfully removed.')
    expect(Order.count).to eq(1)
    expect(OrderItem.count).to eq(0)
  end
end
