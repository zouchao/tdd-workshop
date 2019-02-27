require 'rails_helper'

RSpec.describe Toy, type: :model do
  before :each do
    @toy = build :toy
  end

  subject { @toy }

  it { should respond_to :title }
  it { should respond_to :price }
  it { should respond_to :published }
  it { should respond_to :user_id }
  it { should be_valid }

  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_presence_of :user_id }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

  it { should belong_to :user }

  describe '#filter_by_title to search toys match title keyword' do
    before :each do
      @toy1 = create :toy, title: 'Ruby boy'
      @toy2 = create :toy, title: 'Elixir girl'
      @toy3 = create :toy, title: 'Redis man'
      @toy4 = create :toy, title: 'Ruby on Rails superman'
    end

    it 'search toys with keyword' do
      expect(Toy.filter_by_title('Ruby')).to match_array([@toy4, @toy1])
    end
  end

  describe 'search by price' do
    before :each do
      @toy1 = create :toy, price: 100
      @toy2 = create :toy, price: 50
      @toy3 = create :toy, price: 150
      @toy4 = create :toy, price: 99
    end

    it 'search toys above or equal to price' do
      expect(Toy.above_or_equal_to_price(100)).to match_array([@toy3, @toy1])
    end

    it 'search toys below or equal to price' do
      expect(Toy.below_or_equal_to_price(100)).to match_array([@toy1, @toy4, @toy2])
    end
  end

  describe '#recent_desc' do
    before :each do
      @toy1 = create :toy
      @toy2 = create :toy
      @toy3 = create :toy
      @toy4 = create :toy
      @toy2.touch
      @toy3.touch
    end
    it 'returns correct ordered toys' do
      expect(Toy.recent_desc).to eq [@toy3, @toy2, @toy4, @toy1]
    end
  end

  describe 'class method #search' do
    before :each do
      @toy1 = create :toy, price: 100, title: 'Ruby boy'
      @toy2 = create :toy, price: 50, title: 'Elixir girl'
      @toy3 = create :toy, price: 150, title: 'Redis man'
      @toy4 = create :toy, price: 99, title: 'Ruby on Rails superman'
      @toy1.touch
    end

    it 'just have keyword and min_price' do
      params = { keyword: 'man', min_price: 100 }
      expect(Toy.search(params)).to match_array([@toy3])
    end

    it 'just have min_price and max_price' do
      params = { min_price: 100, max_price: 100 }
      expect(Toy.search(params)).to match_array([@toy1])
    end

    it 'just have keyword and max_price and order' do
      params = { keyword: 'R', max_price: 100, order: 'desc' }
      expect(Toy.search(params)).to eq [@toy1, @toy4]
    end

    it 'no condition match' do
      params = { keyword: 'Ruby', max_price: 90 }
      expect(Toy.search(params)).to eq []
    end

    it 'params is empty' do
      params = {}
      expect(Toy.search(params)).to match_array(Toy.all)
    end
  end
end
