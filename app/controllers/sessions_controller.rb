class SessionsController < ApplicationController
  
  skip_before_filter :authorize
  
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:name], params[:password])
      session[:user_id] = user.id
      if user.admin?
        session[:admin] = user.admin
      end
      redirect_to store_url
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, :notice => "Logged Out!"
  end
end
