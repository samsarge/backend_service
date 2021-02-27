# The backend for an app, used to distinguish tenants with Apartment
# wraps databases etc, everything under this tenant should be namespaced

# AKA API, just calling it backend because it will likely wrap all backend functionality
# for apps later on.
class Backend < ApplicationRecord
  belongs_to :user

  has_one :configuration, dependent: :destroy

  SUBDOMAIN_REGEX = /\A[a-zA-Z0-9\-]+\z/.freeze
  RESERVED_SUBDOMAINS = ['www', 'api', 'test', 'subdomain'].freeze

  after_create :create_default_configuration!
  after_create :create_schema_tenant!
  after_destroy :drop_schema_tenant!

  validates :name, presence: true

  validate :subdomain_isnt_reserved

  # Subdomain is used for tenant names
  validates :subdomain,
            presence: true,
            uniqueness: true,
            format: { with: SUBDOMAIN_REGEX }

  private

  # Until we make it a required nested attribute as part of a UX overhaul
  def create_default_configuration!
    Configuration.create(backend: self)
  end

  def subdomain_isnt_reserved
    return unless subdomain.downcase.in? RESERVED_SUBDOMAINS

    errors.add(:subdomain, "#{subdomain} is a reserved subdomain")
  end

  def create_schema_tenant!
    Apartment::Tenant.create(subdomain)
  end

  def drop_schema_tenant!
    Apartment::Tenant.drop(subdomain)
  end
end
