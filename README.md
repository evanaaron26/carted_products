# Product Orders

This repository is the basic setup to practice creating a shopping cart. It has a Product table, an Order table, and a CartedProducts table. The CartedProducts table represents the objects that have been placed into the cart before purchase.

* clone the repo

* bundle

* rails db:create

* rails db:migrate

* rails db:seed

* rails server

```

// break association between carted_products and orders for now
// app/models - look at associations
// app/controllers - look at controllers
  add t.string :status to CartedProducts

// products show.html.erb

<%= form_tag "/carted_products", method: :post do %>
  <div>
    <%= label_tag :quantity %>
    <%= text_field_tag :quantity %>
  </div>
  <div>
    <%= hidden_field_tag :product_id, @product.id %>
  </div>
  <div>
    <%= submit_tag "Add To Cart" %>
  </div>
<% end %>

// routes
  post "/orders" => 'orders#create'
  get "/orders/:id" => 'orders#show'
  post "/carted_products" => 'carted_products#create'

// add to CartedProducts controller

  def create
    CartedProduct.create(
      product_id: params[:product_id],
      quantity: params[:quantity],
      status: "carted")
    redirect_to "/carted_products"
  end

// add to CartedProducts controller

  def index
    @carted_products = CartedProduct.where(status: "carted")
  end

// add route
get "/carted_products" => 'carted_products#index’

// add to carted_products index.html.erb

<h1>Checkout Page</h1>

<% @carted_products.each do |carted_product| %>
  <h2><%= carted_product.product.name %> - Quantity: <%= carted_product.quantity %></h2>
<% end %>

<br>
<a href="/products">go to all products</a>
<br><br>
<%= form_tag "/orders", method: :post do %>
  <%= submit_tag "Buy Now!" %>
<% end %>


// routes

get "/carted_products" => 'carted_products#index'

// carted_products controller

  def index
    @carted_products = CartedProduct.where(status: "carted")
  end

  def create
    # order = Order.last

    CartedProduct.create(
      product_id: params[:product_id],
      quantity: params[:quantity],
      order_id: 1,
      status: "carted"
      )
    redirect_to "/carted_products"
  end

// orders controller

class OrdersController < ApplicationController
  SALES_TAX = 0.09

  def show
    @order = Order.find_by(id: params[:id])
  end

  def create
    @carted_products = CartedProduct.where(status: "carted")

    #########TODO: move this stuff to models
    subtotal = 0
    @carted_products.each do |carted_product|
      subtotal += carted_product.quantity * carted_product.product.price
    end

    tax = subtotal * SALES_TAX
    total = subtotal + tax

    order = Order.create(subtotal: subtotal, tax: tax, total: total)
    @carted_products.update_all(status: "purchased", order_id: order.id)

    redirect_to "/orders/#{order.id}"
  end
end

// application.html.erb

<%= link_to "Shopping Cart", "/carted_products" %>
```