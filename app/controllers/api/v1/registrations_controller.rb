module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :verify_authenticity_token

      respond_to :json

      def create
        build_resource(sign_up_params)

        return render_validation_error(resource) unless resource.save

        render json: UserSerializer.new(resource).serialized_json
      end

      def render_resource(resource)
        if resource.errors.empty?
          render json: Multitenanted::UserSerializer.new(resource).serialized_json
        else
          render_validation_error(resource)
        end
      end

      def render_validation_error(resource)
        render json: {
          errors: [
            {
              status: '422',
              title: 'Unprocessable Entity',
              detail: resource.errors,
              code: '422'
            }
          ]
        }, status: :unprocessable_entity
      end
    end
  end
end
