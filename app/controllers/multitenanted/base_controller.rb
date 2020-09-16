module Multitenanted
  class BaseController < ApplicationController

    # Might be worth making an elevator for this and have it run on every controller
    # that inherits from this controller

    around_action :execute_in_tenant

    protected

    def backend
      @backend ||= current_user.backends.find(params[:backend_id])
    end

    def execute_in_tenant
      Apartment::Tenant.switch!(backend.subdomain)
      yield
    end
  end
end
