require 'rails_helper'

feature 'List of Product' do
  let!(:customer) { create :customer }
  let!(:first_product) { create :product }
  let!(:second_product) { create :product }

  before do
    sign_in customer
    visit products_path
  end

  it do
    expect(page).to have_content('Listing products')
    expect(page).to have_content(first_product.name)
    expect(page).to have_content(second_product.name)
  end
end
