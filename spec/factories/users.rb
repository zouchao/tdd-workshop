FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@toys.com" }
    password { '123456789' }
    password_confirmation { '123456789' }
  end
end
