redis_connection = if Rails.env.production?
  Redis.new(url: ENV['REDIS_URL'])
else
  Redis.new # Defaults to localhost
end

CACHE = Redis::Namespace.new('cache', redis: redis_connection).freeze

# increment a cache version so we can implement reset mechanisms for the cache
# every time we deploy.
CACHE.set('cache_version', DateTime.now.to_i)
