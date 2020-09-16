module Multitenanted
  class TablesController < Multitenanted::BaseController
    before_action :multitenanted_table, only: [:show, :edit, :update, :destroy]

    def show; end

    def new
      @multitenanted_table = Multitenanted::Table.new
    end

    def edit; end

    def create
      @multitenanted_table = Multitenanted::Table.new(multitenanted_table_params)

      if @multitenanted_table.save
        redirect_to @backend, notice: 'Table was successfully created.'
      else
        render :new
      end
    end

    def update
      if @multitenanted_table.update(multitenanted_table_params)
        redirect_to(
          backend_multitenanted_table_path(backend_id: @backend.id, id: @multitenanted_table.id),
          notice: 'Table was successfully updated.'
        )
      else
        render :edit
      end
    end

    def destroy
      @multitenanted_table.destroy
      redirect_to multitenanted_tables_url, notice: 'Table was successfully destroyed.'
    end

    private

    def multitenanted_table
      @multitenanted_table ||= Multitenanted::Table.find(params[:id])
    end

    def multitenanted_table_params
      params.tap do |params|
        params[:multitenanted_table][:structure] = parsed_json_input(
          params[:multitenanted_table][:structure]
        )
      end.require(:multitenanted_table).permit(:name, structure: {})
    end
  end
end
