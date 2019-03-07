require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  describe 'GET #show' do
    let(:user) { create :user }
    let(:order) { create :order, user: user }
    before :each do
      api_authorization_header user.auth_token
      get :show, params: { id: order.id, user_id: user }
    end

    it { should respond_with 200 }

    it 'returns a current user order response' do
      expect(json_response[:data]).to be_present
    end

    it 'retuns user relationships in order' do
      expect(json_response[:data][:relationships][:user][:data][:id].to_i).to eq user.id
    end
  end

  describe 'GET #index' do
    let(:user) { create :user }
    before :each do
      api_authorization_header user.auth_token
      4.times { create :order, user: user }
      get :index, params: { user_id: user }
    end

    it { should respond_with 200 }

    it 'returns current user orders response' do
      expect(json_response[:data]).to be_present
    end

    it 'returns correct order number' do
      expect(json_response[:data].count).to eq 4
    end
  end

  describe 'POST #create' do
    let(:user) { create :user }
    let(:toy1) { create :toy }
    let(:toy2) { create :toy }
    let(:toy3) { create :toy }

    context 'when created successfully' do
      before :each do
        api_authorization_header user.auth_token
        post :create, params: { order: { toy_ids: [toy1.id, toy2.id, toy3.id] }, user_id: user.id }
      end

      it { should respond_with 201 }

      it 'returns the user order record' do
        expect(json_response[:data]).to be_present
      end

      it 'returns the order record just created' do
        expect(json_response[:data][:attributes][:user_id]).to eq user.id
      end
    end
  end
end
