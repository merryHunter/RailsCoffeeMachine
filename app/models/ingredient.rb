class Ingredient < ActiveRecord::Base
  attr_accessible :price, :title, :amount
  validates :title, :uniqueness => true
  validates :price, :numericality => {greater_than_or_equal_to: 0.01}
  validates :price, :numericality => {greater_than_or_equal_to: 1}
end
