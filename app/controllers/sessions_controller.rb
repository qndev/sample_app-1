class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      log_in user
      remember_password user
      redirect_back_or user
    else
      flash[:danger] = t"static_pages.login.error_message"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def remember_password user
    checked = params[:session][:remember_me]
    checked == Settings.user.remember_user ? remember(user) : forget(user)
  end
end
