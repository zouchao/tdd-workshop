class Toy < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :user
  has_many :placements
  has_many :orders, through: :placements

  scope :filter_by_title, -> (keyword) { where('title LIKE ?', "%#{keyword}%") }
  scope :above_or_equal_to_price, -> (price) { where('price >= ?', price) }
  scope :below_or_equal_to_price, -> (price) { where('price <= ?', price) }
  scope :recent_desc, -> { order('updated_at desc') }

  def self.search(params = {})
    toys = Toy.all
    toys = toys.filter_by_title(params[:keyword]) if params[:keyword].present?
    toys = toys.above_or_equal_to_price(params[:min_price]) if params[:min_price].present?
    toys = toys.below_or_equal_to_price(params[:max_price]) if params[:max_price].present?
    toys = toys.recent_desc if params[:order].present?
    toys
  end
end
