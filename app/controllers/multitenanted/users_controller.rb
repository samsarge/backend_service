module Multitenanted
  class UsersController < Multitenanted::BaseController
    before_action :multitenanted_user, only: [:show, :edit, :update, :destroy]

    def index
      @multitenanted_users = Multitenanted::User.all
    end

    def show; end

    def new
      @multitenanted_user = Multitenanted::User.new
    end

    def edit; end

    def create
      @multitenanted_user = Multitenanted::User.new(multitenanted_user_params)

      if @multitenanted_user.save
        redirect_to @multitenanted_user, notice: 'user was successfully created.'
      else
        render :new
      end
    end

    def update
      if @multitenanted_user.update(multitenanted_user_params)
        redirect_to @multitenanted_user, notice: 'user was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @multitenanted_user.destroy
      redirect_to(backend_multitenanted_users_path(backend_id: backend.id), notice: 'user was successfully destroyed.')
    end

    private

    def multitenanted_user
      @multitenanted_user ||= Multitenanted::User.find(params[:id])
    end

    def multitenanted_user_params
      params.require(:multitenanted_user).permit(:email)
    end
  end
end
