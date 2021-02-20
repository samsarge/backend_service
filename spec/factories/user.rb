# Normal users

FactoryBot.define do
  factory :user do
    email  { 'tester@test.com' }
    password { 'asdASD123!@£' }
  end
end
