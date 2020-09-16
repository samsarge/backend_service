sym = Rails.env.production? ? :chargebee_production_key : :chargebee_test_key

ChargeBee.configure(site: "your-site-1594645280725-test",
                    api_key: Rails.application.credentials.dig(sym))

1
