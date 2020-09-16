class CreateBackends < ActiveRecord::Migration[6.0]
  def change
    create_table :backends do |t|
      t.string :name
      t.string :subdomain
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
