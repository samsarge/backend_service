json.extract! multitenanted_record, :id, :values, :multitenanted_table_id, :created_at, :updated_at
json.url multitenanted_record_url(multitenanted_record, format: :json)
