module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :verify_authenticity_token

      respond_to :json

      rescue_from NoPermissionError, with: :forbidden

      before_action do
        backend = Backend.find_by(subdomain: Apartment::Tenant.current)
        PermissionChecker.new(backend).user_registration_actions
      end

      def create
        build_resource(sign_up_params)

        return render json: resource.errors, status: :unprocessable_entity unless resource.save

        render json: resource
      end

      def render_resource(resource)
        if resource.errors.empty?
          render json: resource
        else
          render json: resource.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
