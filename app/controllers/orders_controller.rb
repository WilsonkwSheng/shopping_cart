class OrdersController < ApplicationController
  before_action :check_authorised_admin, only: [:all_orders]

  def all_orders
    orders_sql = <<~SQL
      SELECT * FROM orders
      ORDER BY ID DESC;
    SQL

    @orders = Order.find_by_sql(orders_sql)
  end

  def add
    pending_order_sql = <<~SQL
      SELECT * FROM orders
      WHERE status = 'pending'
      AND customer_id = #{current_customer.id}
      ORDER BY ID DESC;
    SQL
    pending_order = current_customer.orders.find_by_sql(pending_order_sql)

    product_sql = <<~SQL
      SELECT * FROM products
      WHERE ID = #{params[:product_id]};
    SQL
    product = Product.find_by_sql(product_sql).first

    if pending_order.blank?
      order = current_customer.orders.build(
        status: 'pending'
      )
    else
      order = pending_order.first
    end

    order.order_items.build(product: product)

    if order.save
      redirect_to orders_path, notice: 'Product was successfully added.'
    else
      render :pending
    end
  end

  private

  def check_authorised_admin
    if !current_customer.admin?
      redirect_to root_path, flash: { error: 'You are not authorised to view this page' }
    end
  end
end