FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email(name: Faker::Name.first_name) }
    password { 'password' }
    password_confirmation { 'password' }
    role { 'customer' }

    trait :admin do
      role { 'admin' }
    end
  end
end
