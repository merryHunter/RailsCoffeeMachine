class Ingredient < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title, :amount
end
