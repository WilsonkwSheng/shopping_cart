require 'rails_helper'

feature 'Update Product' do
  let!(:customer) { create :customer, :admin }
  let!(:product) { create :product }
  let!(:edit_product) { build_stubbed :product }

  before do
    sign_in customer
    visit edit_product_path(product)
  end

  it do
    fill_in 'Name', with: edit_product.name
    click_button 'Save'

    expect(page).to have_content('Product was successfully updated.')
    expect(Product.find_by(name: edit_product.name).present?).to eq(true)
  end

  context 'customer role' do
    let!(:customer) { create :customer }

    it do
      expect(page).to have_content('You are not authorised to view this page')
    end
  end
end
