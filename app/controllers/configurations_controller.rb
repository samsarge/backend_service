class ConfigurationsController < ApplicationController
  before_action :backend, :configuration

  def show; end

  def edit; end

  def update
    return render :edit unless configuration.update(configuration_params)

    redirect_to edit_backend_configuration_path(backend_id: params[:backend_id]),
                notice: 'Configuration was successfully updated.'
  end

  private

  def backend
    @backend ||= current_user.backends.find(params[:backend_id])
  end

  def configuration
    @configuration ||= backend.configuration
  end

  def configuration_params
    params.require(:configuration).permit(
      :user_sessions_enabled, :user_registrations_enabled, :custom_data_enabled
    )
  end
end
