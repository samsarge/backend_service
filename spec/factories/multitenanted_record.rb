# Normal users

FactoryBot.define do
  factory :multitenanted_record, class: 'Multitenanted::Record'  do
    values { { name: 'Sam', email: 'bestrubydev@test.com', phone: '077777777777' } }
  end
end
