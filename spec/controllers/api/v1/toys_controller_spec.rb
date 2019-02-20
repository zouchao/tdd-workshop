require 'rails_helper'

RSpec.describe Api::V1::ToysController, type: :controller do

  describe 'GET #show' do
    before :each do
      @toy = create :toy
      get :show, params: { id: @toy.id }
    end

    it { should respond_with 200 }

    it 'returns a user response' do
      expect(json_response[:data][:attributes][:title]).to eq @toy.title
    end
  end
end
