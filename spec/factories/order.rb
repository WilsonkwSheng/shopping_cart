FactoryBot.define do
  factory :order do
    status { 'pending' }
    customer

    trait :paid do
      status { 'paid' }
    end
  end
end
