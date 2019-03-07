class OrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :user_id, :total, :created_at

  belongs_to :user
  has_many :toys
  has_many :placements
end
