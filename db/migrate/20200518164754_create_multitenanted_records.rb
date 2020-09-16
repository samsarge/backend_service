class CreateMultitenantedRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :multitenanted_records do |t|
      t.jsonb :values, default: {}
      t.references :multitenanted_table, null: false, foreign_key: true

      t.timestamps
    end
  end
end
