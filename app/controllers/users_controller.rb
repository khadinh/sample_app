class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate page: params[:page]
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "flash.find_user_fail"
    redirect_to signup_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t "flash.success"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flash.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = t "flash.deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
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
end
