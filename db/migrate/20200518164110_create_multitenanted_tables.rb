class CreateMultitenantedTables < ActiveRecord::Migration[6.0]
  def change
    create_table :multitenanted_tables do |t|
      t.string :name
      t.jsonb :structure, default: {"columns"=>[]}

      t.timestamps
    end
  end
end
