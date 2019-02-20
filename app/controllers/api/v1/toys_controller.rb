class Api::V1::ToysController < ApplicationController

  def show
    @toy = Toy.find_by id: params[:id]
    render json: ToySerializer.new(@toy)
  end
end
