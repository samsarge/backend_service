class BackendsController < ApplicationController
  before_action :backend, only: [:show, :edit, :update, :destroy]

  # TODO: Forbid unless current user

  def index
    @backends = current_user.backends.all
  end

  def show
    Apartment::Tenant.switch!(backend.subdomain)
    @tables = Multitenanted::Table.all
  end

  def new
    @backend = current_user.backends.new
  end

  def edit; end

  def create
    @backend = current_user.backends.new(backend_params)

    return render :new unless @backend.save

    redirect_to @backend, notice: 'Backend was successfully created.'
  end

  def update
    return render :edit unless @backend.update(backend_params)

    redirect_to @backend, notice: 'Backend was successfully updated.'
  end

  def destroy
    @backend.destroy

    redirect_to backends_url, notice: 'Backend was successfully destroyed.'
  end

  private

  def backend
    @backend ||= current_user.backends.find(params[:id])
  end

  def backend_params
    params.require(:backend).permit(:name, :subdomain)
  end
end
