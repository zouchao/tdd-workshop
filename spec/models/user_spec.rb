require 'rails_helper'

RSpec.describe User, type: :model do

  before :each do
    @user = build :user
  end

  subject { @user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of :password }
  it { should allow_value('example@domain.com').for(:email) }

end
