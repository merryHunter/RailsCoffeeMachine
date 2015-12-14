class OrdersController < ApplicationController
  
  skip_before_filter :authorize, :only => [:new, :create]
  
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @cart = current_cart
    
    if @cart.line_items.empty?
      redirect_to store_url, :notice => "your cart is empty!"
      return
    end

    @order = Order.new
    @order.add_line_items_from_cart(current_cart)
    logger.debug("DEBUG_ORDER")
    logger.debug(session[:user_id])
    logger.debug(params[:user_id])
    # decrease user money
    @user = User.find_by_id(session[:user_id])
    @user.credit -= current_cart.total_price
    @user.save
    @order.cart_id = @cart.id
    @order.user_id = @user.id
    @order.name = @user.id.to_s
    @order.price = current_cart.total_price
    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
    end
    redirect_to store_url, :notice => "Successful!"
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        # Notifier.order_received(@order)
        format.html { redirect_to store_url, notice: 'Thank you for your order!' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end
