class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :index_action, only: :index

  def index
    redirect_to root_path unless @user

    @title = t "#{params[:type]}.title"
    @users = @user.send(params[:type]).paginate(
      page: params[:page],
      per_page: Settings.user.per_page
    )
    render "users/show_follow"
  end

  def create
    @user = User.find_by params[:followed_id]
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by(params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def index_action
    @user = User.find_by id: params[:user_id]
  end
end
