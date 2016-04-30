class SessionsController < ApplicationController

  before_action :redirect_if_loggedin, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to root_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Wrong credentials!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

  private

  def redirect_if_loggedin
    redirect_to root_path, notice: "Already logged in!" if user_signed_in?
  end
end
