class Order < ActiveRecord::Base
  attr_accessible :cart_id, :name, :user_id, :price
  
  has_many :line_items, :dependent => :destroy
  belongs_to :cart
  belongs_to :user

      def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  
end
