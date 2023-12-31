require 'rails_helper'

feature 'Create Product' do
  let!(:customer) { create :customer, :admin }
  let(:product) { build_stubbed :product }

  before do
    sign_in customer
    visit new_product_path
  end

  it do
    fill_in 'Name', with: product.name
    click_button 'Save'

    expect(page).to have_content('Product was successfully created.')
    expect(Product.find_by(name: product.name).present?).to eq(true)
  end

  context 'customer role' do
    let!(:customer) { create :customer }

    it do
      expect(page).to have_content('You are not authorised to view this page')
    end
  end
end
