# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

PRODUCTS = [
  'Nintendo Switch',
  'The Hobbit',
  'Samsung Neo QLED',
  'IPhone15'
]

PRODUCTS.each do |product|
  Product.find_or_create_by(name: product)
end

Customer.find_or_create_by(name: 'admin') do |customer|
  customer.email = 'admin@example.com'
  customer.password = 'password'
end

CUSTOMERS = [
  'customerone',
  'customertwo',
]

CUSTOMERS.each do |customer_name|
  customer = Customer.find_or_create_by(name: customer_name) do |customer|
    customer.email = "#{customer_name}@example.com"
    customer.password = 'password'
    customer.role = 'admin'
  end
end

CUSTOMERS.each do |customer_name|
  customer_sql = <<~SQL
    SELECT * FROM customers
    WHERE name = ?
  SQL

  customer = Customer.find_by_sql([customer_sql, customer_name]).first
  if customer.present?
    order = customer.orders.build(status: 'paid')
    PRODUCTS.sample(2).each do |product_name|
      product_sql = <<~SQL
        SELECT * FROM products
        WHERE name = ?
      SQL
      product = Product.find_by_sql([product_sql, product_name]).first
      order.order_items.build(product: product)
    end
    order.save!
  end
end
