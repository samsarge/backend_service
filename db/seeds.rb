# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

User.create!(email: 'test@test.com', password: 'test@test.com')

User.last.backends.create!(name: 'test app', subdomain: 'testapp')

Apartment::Tenant.switch!(Backend.last.subdomain)


Multitenanted::Table.create!(name: 'contacts',
  structure: {
    columns: [
      { name: 'name', datatype: 'String' },
      { name: 'email', datatype: 'String' },
      { name: 'phone', datatype: 'String' }
    ]
  }
)

Multitenanted::Table.last.records.create!(values: { name: 'contact1', email: 'contact1@email.com' })

Apartment::Tenant.switch! # back to public schema