module Multitenanted
  class RecordsController < Multitenanted::BaseController
    before_action :multitenanted_record, only: [:show, :edit, :update, :destroy]

    def index
      @multitenanted_records = Multitenanted::Record.all
    end

    def show; end

    def new
      @multitenanted_record = Multitenanted::Record.new
    end

    def edit; end

    def create
      @multitenanted_record = Multitenanted::Record.new(multitenanted_record_params)

      if @multitenanted_record.save
        redirect_to @multitenanted_record, notice: 'Record was successfully created.'
      else
        render :new
      end
    end

    def update
      if @multitenanted_record.update(multitenanted_record_params)
        redirect_to @multitenanted_record, notice: 'Record was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @multitenanted_record.destroy
      redirect_to(
        backend_multitenanted_table_path(backend_id: backend.id, id: table.id),
        notice: 'Record was successfully destroyed.'
      )
    end

    private

    def multitenanted_record
      @multitenanted_record ||= Multitenanted::Record.find(params[:id])
    end

    def table
      multitenanted_record.table
    end

    def multitenanted_record_params
      params.require(:multitenanted_record).permit(values: {})
    end
  end
end
