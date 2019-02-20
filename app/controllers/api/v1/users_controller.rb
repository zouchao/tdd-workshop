class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]

  def show
    @user = User.find_by id: params[:id]
    render json: UserSerializer.new(@user)
  end

  def create
    user = User.new user_params
    if user.save
      render json: UserSerializer.new(user), status: 201
    else
      render json: { errors: ErrorSerializer.new(user).serialized_json }, status: 422
    end
  end

  def update
    if current_user.update_attributes user_params
      render json: UserSerializer.new(current_user), status: 200
    else
      render json: { errors: ErrorSerializer.new(current_user).serialized_json }, status: 422
    end
  end

  def destroy
    current_user.destroy
    render status: 204, json: { message: 'Deleted' }
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
