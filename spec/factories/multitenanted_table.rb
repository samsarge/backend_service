# Normal users

FactoryBot.define do
  factory :multitenanted_table, class: 'Multitenanted::Table'  do
    name { 'contacts' }
    structure {
      {
        columns: [
          { name: 'name', datatype: 'String' },
          { name: 'email', datatype: 'String' },
          { name: 'phone', datatype: 'String' }
        ]
      }
    }
  end
end
