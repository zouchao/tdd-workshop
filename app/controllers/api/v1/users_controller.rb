class Api::V1::UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    render json: @user
  end
end
