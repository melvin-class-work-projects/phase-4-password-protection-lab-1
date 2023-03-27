class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    if current_user
      render json: current_user, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  private

  def user_params
    if params[:user].present?
      params.require(:user).permit(:username, :password, :password_confirmation)
    else
      {}
    end
  end

  def authenticate_user(user_params)
    user = User.find_by(username: user_params[:username])
    if user && user.authenticate(user_params[:password])
      user
    else
      nil
    end
  end  

end
