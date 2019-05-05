class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_param, only: [:edit, :update, :destroy]

  def index
    @users = User.order(:name).paginate(
      page: params[:page],
      per_page: Settings.user.per_page
    )
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t("static_pages.home.welcome")
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.order("created_at DESC").page params[:page]
  end

  def edit
    @user = find_param
  end

  def update
    @user = find_param
    if @user.update(user_params)
      flash[:success] = t("static_pages.users.new.profile_updated")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    find_param.destroy
    flash[:success] = t("static_pages.users.delete.deleted")
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
    flash[:danger] = t("static_pages.users.new.login_require")
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_param
    User.find(params[:id])
  end
end
