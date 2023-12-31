require 'rails_helper'

feature 'Add product to ongoing pending order' do
  let(:customer) { create :customer }
  let!(:product_one) { create :product }

  before do
    sign_in customer
    visit products_path
  end

  it do
    click_on 'Add to cart'

    expect(page).to have_content('Product was successfully added.')
    order = customer.orders.find_by(status: 'pending')
    expect(order.products.present?).to eq(true)
  end
end
