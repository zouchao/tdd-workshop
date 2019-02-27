class Api::V1::ToysController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]


  def index
    toys = Toy.search params
  end

  def show
    @toy = Toy.find_by id: params[:id]
    render json: ToySerializer.new(@toy)
  end

  def create
    toy = current_user.toys.new toy_params
    if toy.save
      render json: ToySerializer.new(toy), status: 201
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  def update
    toy = current_user.toys.find_by id: params[:id]
    return render json: { errors: 'params invalid' }, status: 422 if toy.blank?

    if toy.update_attributes toy_params
      render json: ToySerializer.new(toy), status: 200
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  def destroy
    toy = current_user.toys.find_by id: params[:id]
    return render json: { errors: 'params invalid' }, status: 422 if toy.blank?
    toy.destroy
    head 204
  end

  private

    def toy_params
      params.require(:toy).permit(:id, :title, :user_id, :price, :published)
    end
end
