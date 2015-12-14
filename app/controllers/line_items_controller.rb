require_relative '../util/validation_strategy'
require_relative '../../app/util/product_no_amount'

class LineItemsController < ApplicationController
  
  skip_before_filter :authorize, :only => :create
  
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    validation = ValidationStrategy.new @cart, params[:user_id], params[:product_id]
    validation.calculation = CreditCalculation

    # if User has enough money to buy it
    if validation.calculation.calculate
      ## try to book the drink
      begin
      validation.calculation = AmountCalculation
      if validation.calculation.calculate
        logger.debug("ADD ORDER ELEMENT")
        flash[:notice] = t('drinks.drink_added')
        @line_item = @cart.add_product(params[:product_id])
        if @line_item.save
          logger.debug("CREATED ORDER ELEMENT")
          respond_to do |format|
            format.html { redirect_to(store_url) }
            format.json { render json: @line_item, status: :created, location: @line_item }
            format.js { @current_item = @line_item }
            end
        end
      end
      rescue ProductNoAmount => e
          flash[:notice] = t('drinks.no_amount')
          logger.error(e.message)
          respond_to do |format|
            format.html { redirect_to(store_url) }
            format.json { render json: @line_item.errors,
                                 status: :unprocessable_entity,
                                 notice: e.message }
            end
      end
      ##
    else
        flash[:notice] = t('no_credit')
        logger.error("NOT ENOUGH CREDIT VALUE")
        respond_to do |format|
            format.html {redirect_to(store_url)}
            format.json { render json: @line_item.errors,
                           status: :unprocessable_entity,
                           notice: 'You do not have enough credit value!' }
        end
    end
  end


  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end
end
