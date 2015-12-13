class StoreController < ApplicationController
  
  skip_before_filter :authorize
  
  def index
    if params[:set_locale]
      redirect_to store_path(locale: params[:set_locale])
    else
      @products = Product.all
      @cart = current_cart
      @ingredients = Ingredient.all
      @user = User.find_by_id(session[:user_id])
      # logger.debug(@user.credit)
    end
  end
end
