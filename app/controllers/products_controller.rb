class ProductsController < ApplicationController
  before_action :check_authorised_admin, only: [:new, :create, :edit, :update]
  before_action :set_product, only: %i[ edit update destroy ]

  def index
    products_sql = <<~SQL
      SELECT * FROM products;
    SQL

    @products = Product.find_by_sql(products_sql)
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to product_url(@product), notice: 'Product was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to product_url(@product), notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name)
  end

  def check_authorised_admin
    if !current_customer.admin?
      redirect_to root_path, flash: { error: 'You are not authorised to view this page' }
    end
  end
end
