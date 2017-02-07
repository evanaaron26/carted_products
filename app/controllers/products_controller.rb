class ProductsController < ApplicationController
  def index
    @products = Product.all
    render 'index.html.erb'

    #go to the product, then buy button
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
  end

  def create
    @product = Product.new(
         name: params[:name],
         price: params[:price]
         )
    @product.save
    flash[:success] = "Product added."
    redirect_to "/products/#{@product.id}"
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.assign_attributes(
         name: params[:_name],
         price: params[:price]
         )
@product.save
    flash[:success] = "Product updated."
    redirect_to "/products/#{@product.id}"
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:success] = "Product deleted."
    redirect_to "/"
  end

end
