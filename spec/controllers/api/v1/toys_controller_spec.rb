require 'rails_helper'

RSpec.describe Api::V1::ToysController, type: :controller do

  describe 'GET #index' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  describe 'GET #show' do
    let(:user) { create :user }
    let(:toy) { create :toy, user: user }
    before :each do
      get :show, params: { id: toy.id }
    end

    it { should respond_with 200 }

    it 'returns a toy response' do
      expect(json_response[:data][:attributes][:title]).to eq toy.title
    end

    it 'retuns user relationships in toy' do
      expect(json_response[:data][:relationships][:user][:data][:id].to_i).to eq user.id
    end
  end

  describe 'POST #create' do
    let(:user) { create :user }
    context 'when created successfully' do
      before :each do
        api_authorization_header user.auth_token
        @toy_attributes = attributes_for :toy
        post :create, params: { toy: @toy_attributes, user_id: user.id }
      end

      it { should respond_with 201 }

      it 'returns the toy record just created' do
        expect(json_response[:data][:attributes][:title]).to eq @toy_attributes[:title]
      end
    end

    context 'when created failed' do
      before :each do
        api_authorization_header user.auth_token
        @invalid_toy_attributes = { price: 12.00 }
        post :create, params: { toy: @invalid_toy_attributes, user_id: user.id }
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

  describe "Put #update" do
    let(:user) { create :user }
    let(:toy) { create :toy, user: user }
    context "when successfully update" do
      before do
        api_authorization_header user.auth_token
        patch :update, params: { user_id: user, id: toy, toy: { title: 'toy_modify' } }
      end

      it { should respond_with 200 }

      it "renders json for the updated toy" do
        expect(json_response[:data][:attributes][:title]).to eq 'toy_modify'
      end
    end

    context "when not updated" do
      before do
        api_authorization_header user.auth_token
        patch :update, params: { user_id: user, id: toy, toy: { title: '' } }
      end

      it { should respond_with 422 }

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json errors on why the toy could not be updated" do
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end
  end

  describe "Delete #destroy" do
    let(:user) { create :user }
    let(:toy) { create :toy, user: user }
    before do
      api_authorization_header user.auth_token
      delete :destroy, params: { user_id: user, id: toy }
    end

    it { should respond_with 204 }
  end
end
