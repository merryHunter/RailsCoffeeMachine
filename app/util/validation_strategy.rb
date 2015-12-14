require 'logger'
require_relative 'product_no_amount'

class ValidationStrategy
  attr_accessor :name, :calculation

  def initialize cart, user_id, product_id
    @cart = cart
    @user_id = user_id
    @product_id = product_id
  end

  def calculation= strategy
    @calculation = strategy.new @cart, @user_id, @product_id
  end


end

class Strategy
  attr_reader :cart, :user, :product

  def initialize cart, user_id, product_id
    @cart = cart
    @user = User.find_by_id(user_id)
    @product = Product.find(product_id)
  end

  def calculate

  end


end

class AmountCalculation < Strategy

  def initialize  cart, user_id, product_id
    super(cart, user_id, product_id)
  end

  # book(decrease) drink amount
  def calculate

    if @product.amount > 0
      @product.amount -= 1
      begin
      @product.save
      rescue ActiveRecord::StandardError
        Rails.logger.info('sql product save error')
        raise ProductNoAmount.new(@product), 'Database error!'
      end
    else
      raise ProductNoAmount.new(@product), 'Drink ' + @product.title + ' has no amount!'
    end
  end
end

class CreditCalculation < Strategy

  def initialize cart, user_id, product_id
    super(cart, user_id, product_id)
  end

  # Calculate if user can afford to buy products
  def calculate
    @cart.total_price + @product.price <= @user.credit
  end
end