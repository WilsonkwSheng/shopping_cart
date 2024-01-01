require 'rails_helper'

feature 'Add to cart with customer ID' do
  let(:customer) { create :customer }
  let!(:product) { create :product }

  before do
    sign_in customer
    visit products_path
  end

  it do
    click_on 'Add to cart'

    expect(page).to have_field("Enter your ID to add this product #{product.name}")
  end
end
