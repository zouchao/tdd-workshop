require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'GET #show' do
    before :each do
      @user = create :user
      4.times { create :toy, user: @user }
      get :show, params: { id: @user.id }
    end

    it { should respond_with 200 }

    it 'returns a user response' do
      expect(json_response[:data][:attributes][:email]).to eq @user.email
    end

    it 'returns toys in user' do
      expect(json_response[:data][:relationships][:toys][:data].count).to eq @user.toys.count
    end
  end

  describe 'POST #create' do
    context 'when created successfully' do
      before :each do
        @user_attributes = attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it { should respond_with 201 }

      it 'returns the user record just created' do
        expect(json_response[:data][:attributes][:email]).to eq @user_attributes[:email]
      end
    end

    context 'when created failed' do
      before :each do
        @invalid_user_attributes = { password: '1234567890', password_confirmation: '1234567890' }
        post :create, params: { user: @invalid_user_attributes }
      end

      it { should respond_with 422 }

      it 'render errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'render errors json with detail message' do
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create :user }

    context 'when updated successfully' do
      before :each do
        api_authorization_header user.auth_token
        @update_attrs = { email: 'superman@sdy.cn' }
        put :update, params: { id: user, user: @update_attrs }
      end

      it { should respond_with 200 }

      it 'returns the user record just created' do
        expect(json_response[:data][:attributes][:email]).to eq @update_attrs[:email]
      end
    end

    context 'when updated failed' do
      before :each do
        api_authorization_header user.auth_token
        @invaild_update_attrs = { email: nil }
        put :update, params: { id: user, user: @invaild_update_attrs }
      end

      it { should respond_with 422 }

      it 'render errors json with detail message' do
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end

    context 'When the id does not exist' do
      before :each do
        api_authorization_header "abcd"
        @update_attrs = { email: 'superman@sdy.cn' }
        put :update, params: { id: 0, user: @update_attrs }
      end

      it { should respond_with 401 }

      it 'render errors json with detail message' do
        expect(json_response[:errors]).to include('Not authenticated')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when deleted successfully' do
      before :each do
        user = create :user
        api_authorization_header user.auth_token
        delete :destroy, params: { id: user }
      end

      it { should respond_with 204 }

      it { expect(User.count).to eq 0 }

      it 'render success json with detail message' do
        expect(json_response[:message]).to include('Deleted')
      end
    end

    context 'When the id does not exist' do
      before :each do
        user = create :user
        delete :destroy, params: { id: 0 }
      end

      it { should respond_with 401 }

      it { expect(User.count).to eq 1 }

      it 'render errors json with detail message' do
        expect(json_response[:errors]).to include('Not authenticated')
      end
    end
  end
end
