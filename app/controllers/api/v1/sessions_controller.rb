module Api
  module V1
    # Overwritten for nesting purposes.
    # respond_to uses respond_with to see the type of req and
    # give an appropriate response automatically.
    class SessionsController < Devise::SessionsController
      rescue_from NoPermissionError, with: :forbidden

      skip_before_action :verify_authenticity_token

      before_action do
        backend = Backend.find_by(subdomain: Apartment::Tenant.current)
        PermissionChecker.new(backend).user_session_actions
      end

      respond_to :json

      private

      def respond_with(resource, _opts = {})
        # TODO: Add user serializer for multitenanted users
        render json: resource
      end

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end
