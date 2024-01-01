require 'rails_helper'

feature 'Add product to ongoing pending order' do
  let(:customer) { create :customer }
  let!(:product) { create :product }
  let(:another_customer) { create :customer }

  before do
    sign_in customer
    visit add_orders_path(product)
  end

  it do
    fill_in :customer_id, with: customer.id
    click_button 'Save'

    expect(page).to have_content('Product was successfully added.')
    order = customer.orders.find_by(status: 'pending')
    expect(order.products.present?).to eq(true)
  end

  context 'invalid customer ID' do
    it do
      fill_in :customer_id, with: another_customer.id
      click_button 'Save'

      expect(page).to have_selector('turbo-stream[action="replace"][target="confirmation_error"]')
      order = customer.orders.find_by(status: 'pending')
      expect(order.present?).to eq(false)
    end
  end
end
