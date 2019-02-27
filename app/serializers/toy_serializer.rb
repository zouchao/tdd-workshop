class ToySerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :price, :published, :user_id, :created_at

  belongs_to :user
end
