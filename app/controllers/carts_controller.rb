class CartsController < ApplicationController
  
  skip_before_filter :authorize, :only => [:create, :update, :destroy]
  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @carts }
    end
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    begin
      @cart = Cart.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, :notice => 'Invalid Cart!'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @cart }
    end
  end
  end

  # GET /carts/new
  # GET /carts/new.json
  def new
    @cart = Cart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cart }
    end
  end

  # GET /carts/1/edit
  def edit
    @cart = Cart.find(params[:id])
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render json: @cart, status: :created, location: @cart }
      else
        format.html { render action: "new" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /carts/1
  # PUT /carts/1.json
  def update
    @cart = Cart.find(params[:id])

    respond_to do |format|
      if @cart.update_attributes(params[:cart])
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  # TODO: return booked amount of drink
  def destroy
    @cart = current_cart
    logger.debug("BEFORE_RETURN_BOOK")
    return_booked_drinks

    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to store_url}
      format.json { head :no_content }
      format.js
    end
  end

  private
    def return_booked_drinks
        @cart.line_items.each do |item|
          logger.debug("RETURN_BOOK" + item.id.to_s)
          product = Product.find_by_id(item.product_id)
          logger.debug("RETURN_BOOK_Q" + item.quantity.to_s)
          product.amount += item.quantity
          product.save
        end
    end
end
