module Multitenanted
  # Multitenanted table object that people use to store data in their backends
  class Table < ApplicationRecord
    has_many :records,
             class_name: 'Multitenanted::Record',
             inverse_of: :table,
             foreign_key: :multitenanted_table_id,
             dependent: :destroy

    validates_with StructureValidator

    validates :name, uniqueness: { presence: true }

    before_save :configure_table_name!
    before_save :underscore_column_names!

    def api_endpoints
      # The backend subdomain + domain
      base = "#{Apartment::Tenant.current}.#{Rails.application.config.domain}"

      {
        Index:   "GET #{base}/api/v1/#{name.pluralize}",
        Show:    "GET #{base}/api/v1/#{name.pluralize}/#{id}",
        Create:  "POST #{base}/api/v1/#{name.pluralize}",
        Update:  "PATCH #{base}/api/v1/#{name.pluralize}/#{id}",
        Update:  "PUT #{base}/api/v1/#{name.pluralize}/#{id}",
        Destroy: "DELETE #{base}/api/v1/#{name.pluralize}/#{id}"
      }
    end

    def json_example
      {
        name.singularize => structure['columns'].each_with_object({}) do |col, hash|
          hash[col] = 'example'
        end
      }.to_json
    end

    private

    def underscore_column_names!
      # see record model, we enforce underscoring
      return unless structure['columns']

      structure['columns'].map!(&:underscore)
    end

    def configure_table_name! # Underscore and pluralize the table name
      self.name = name.squish.downcase.tr(' ', '_').pluralize
    end
  end
end
