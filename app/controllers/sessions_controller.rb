class SessionsController < ApplicationController
  def new; end

  before_action :fetch_user_by_email, only: :create

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      checked = params[:session][:remember_me] == Settings.checked_rememberme
      checked ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = t "flash.invalid_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def fetch_user_by_email
    @user = User.find_by email: params[:session][:email].downcase
  end
end
