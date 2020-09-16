# The backend for an app, used to distinguish tenants with Apartment
# wraps databases etc, everything under this tenant should be namespaced
class Backend < ApplicationRecord
  belongs_to :user

  SUBDOMAIN_REGEX = /\A[a-zA-Z0-9\-]+\z/.freeze

  after_create :create_schema_tenant!
  after_destroy :drop_schema_tenant!

  # Subdomain is used for tenant names
  validates :subdomain,
            presence: true,
            uniqueness: true,
            format: { with: SUBDOMAIN_REGEX }

  private

  def create_schema_tenant!
    Apartment::Tenant.create(subdomain)
  end

  def drop_schema_tenant!
    Apartment::Tenant.drop(subdomain)
  end
end
