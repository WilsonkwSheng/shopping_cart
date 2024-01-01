class OrdersController < ApplicationController
  before_action :check_authorised_admin, only: [:all_orders]

  def all_orders
    orders_sql = <<~SQL
      SELECT * FROM orders
      ORDER BY ID DESC;
    SQL

    @orders = Order.find_by_sql(orders_sql)
  end

  def index
    pending_order_sql = <<~SQL
      SELECT * FROM orders
      WHERE status = 'pending'
      AND customer_id = #{current_customer.id}
      ORDER BY ID DESC;
    SQL

    paid_orders_sql = <<~SQL
      SELECT * FROM orders
      WHERE status = 'paid'
      AND customer_id = #{current_customer.id}
      ORDER BY orders.ID DESC;
    SQL

    @pending_order = Order.find_by_sql(pending_order_sql)
    @orders = Order.find_by_sql(paid_orders_sql)
  end

  def add
    product_sql = <<~SQL
      SELECT * FROM products
      WHERE ID = #{params[:product_id]};
    SQL
    @product = Product.find_by_sql(product_sql)
  end

  def checkout
    pending_order_sql = <<~SQL
      SELECT * FROM orders
      WHERE status = 'pending'
      AND customer_id = #{current_customer.id}
      ORDER BY ID DESC;
    SQL
    pending_order = Order.find_by_sql(pending_order_sql)

    if pending_order.first.update(status: 'paid')
      redirect_to orders_path, notice: 'Order was successfully paid.'
    else
      render :index
    end
  end

  def destroy
    pending_order_sql = <<~SQL
      SELECT * FROM orders
      WHERE status = 'pending'
      AND customer_id = #{current_customer.id}
      ORDER BY ID DESC;
    SQL
    pending_order = Order.find_by_sql(pending_order_sql)

    if pending_order.first.destroy
      redirect_to orders_path, notice: 'Order was successfully removed.'
    else
      render :index
    end
  end

  def remove
    pending_order_sql = <<~SQL
      SELECT * FROM orders
      WHERE status = 'pending'
      AND customer_id = #{current_customer.id}
      ORDER BY ID DESC;
    SQL
    pending_order = Order.find_by_sql(pending_order_sql)

    order_item = pending_order.first.order_items.find_by(product_id: params[:product_id])
    if order_item.destroy
      redirect_to orders_path, notice: 'Product was successfully removed.'
    else
      render :index
    end
  end

  def confirmation
    if params[:customer_id] != current_customer.id.to_s
      return render turbo_stream: turbo_stream.replace('confirmation_error', partial: 'error', locals: { error: 'Please enter your customer ID to continue' })
    end

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
      render turbo_stream: turbo_stream.replace('confirmation_error', partial: 'error', locals: { error: order.errors.full_messages })
    end
  end

  private

  def check_authorised_admin
    if !current_customer.admin?
      redirect_to root_path, flash: { error: 'You are not authorised to view this page' }
    end
  end
end
