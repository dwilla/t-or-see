class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show ]
  def show
    @events = Event.where(creator_id: @user.id)
  end

  private
  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "User not found"
    end
  end

  def user_params
    params.require(:user).permit(:username)
  end
end
