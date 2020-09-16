module Multitenanted
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :rememberable, :validatable,
           :trackable,
           :jwt_authenticatable,
           jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
           #:recoverable # Add back in when we need it

    def jwt_payload
      { subdomain: Apartment::Tenant.current }
    end
  end
end
