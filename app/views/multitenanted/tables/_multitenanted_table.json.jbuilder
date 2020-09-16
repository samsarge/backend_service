json.extract! multitenanted_table, :id, :name, :structure, :created_at, :updated_at
json.url multitenanted_table_url(multitenanted_table, format: :json)
