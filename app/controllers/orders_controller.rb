class OrdersController < ApplicationController
  before_action :check_authorised_admin, only: [:all_orders]

  def all_orders
    orders_sql = <<~SQL
      SELECT * FROM orders
      ORDER BY ID DESC;
    SQL

    @orders = Order.find_by_sql(orders_sql)
  end

  private

  def check_authorised_admin
    if !current_customer.admin?
      redirect_to root_path, flash: { error: 'You are not authorised to view this page' }
    end
  end
end
