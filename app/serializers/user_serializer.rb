class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :created_at, :updated_at, :auth_token

  has_many :toys
end
