# Normal users

FactoryBot.define do
  factory :multitenanted_table, class: 'Multitenanted::Table'  do
    name { 'contacts' }
    structure { { columns: %w[name email phone] } }
    permission_bitmask { 15 }
  end
end
