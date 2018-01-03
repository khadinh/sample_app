class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def hello
    render html: "hello, world!"
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "flash.not_login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def fetch_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "flash.find_user_fail"
    redirect_to signup_path
  end
end
