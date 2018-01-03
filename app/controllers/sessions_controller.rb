class SessionsController < ApplicationController
  def new; end

  before_action :fetch_user, only: :create

  def create
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        checked = params[:session][:remember_me] == Settings.checked_rememberme
        checked ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = t "flash.warning_activate"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "flash.invalid_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

def fetch_user
  @user = User.find_by email: params[:session][:email].downcase
end
