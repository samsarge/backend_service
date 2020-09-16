json.extract! backend, :id, :name, :subdomain, :user_id, :created_at, :updated_at
json.url backend_url(backend, format: :json)
