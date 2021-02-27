class AddPermissionBitmaskToMultitenantedTables < ActiveRecord::Migration[6.0]
  def change
    add_column :multitenanted_tables, :permission_bitmask, :integer, default: 15
  end
end
