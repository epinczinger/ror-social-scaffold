class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    @pending = @user.pending_friends
    @to_answer = @user.friend_requests
  end

  def update
    @user = User.find(params[:user_id])

    if current_user.confirm_friend(@user)
      redirect_to users_path, notice: 'Friendship invitation accepted.'
    else
      redirect_to users_path, alert: 'Something went wrong accepting the invitation.'
    end
  end

   def destroy
    @user = User.find(params[:user_id])

    if current_user.reject_request(@user)
      redirect_to users_path, notice: 'Friendship request denied.'
    else
      redirect_to users_path, alert: 'Something went wrong rejecting the invitation.'
    end
  end
end
