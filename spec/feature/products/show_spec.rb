require 'rails_helper'

feature 'Product details' do
  let!(:customer) { create :customer }
  let!(:product) { create :product }

  before do
    sign_in customer
    visit product_path(product)
  end

  it do
    expect(page).to have_content(product.name)
  end
end
