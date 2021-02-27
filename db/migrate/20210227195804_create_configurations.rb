class CreateConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :configurations do |t|

      t.boolean :user_sessions_enabled, default: true
      t.boolean :user_registrations_enabled, default: true
      t.boolean :custom_data_enabled, default: true

      t.references :backend, null: false, foreign_key: true

      t.timestamps
    end
  end
end
