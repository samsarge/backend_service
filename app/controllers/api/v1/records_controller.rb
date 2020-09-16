module Api
  module V1
    # Multitenanted records
    # Implement fast json api serializer
    class RecordsController < ApplicationController
      skip_before_action :verify_authenticity_token # cause api, but should cors probably later

      rescue_from ActiveRecord::RecordNotFound, with: proc { render ::JsonResponse.not_found }

      def index
        records = table.records
        render json: ::Multitenanted::RecordSerializer.new(records).serialized_json
      end

      def show
        record = table.records.find(params[:id])
        render json: ::Multitenanted::RecordSerializer.new(record).serialized_json
      end

      def create
        record = table.records.new(values: dynamic_record_params)
        if record.save
          render json: ::Multitenanted::RecordSerializer.new(record).serialized_json
        else
          render ::JsonResponse.validation_error(record)
        end
      end

      def update
        record = table.records.find(params[:id])
        if record.update(values: dynamic_record_params)
          render json: ::Multitenanted::RecordSerializer.new(record).serialized_json
        else
          render ::JsonResponse.validation_error(record)
        end
      end

      def destroy
        record = table.records.find(params[:id])
        # Ok well we shouldn't allow everyone to just destroy everything? Maybe we even remove this
        # URL or something? No idea
        return head(:no_content) if record.destroy
        
        render ::JsonResponse.validation_error(record)
      end

      private

      def dynamic_record_params
        model = table.name.singularize
        params.require(model).permit(*table.structure["columns"])
      end

      def backend
        @backend ||= Backend.find_by(subdomain: Apartment::Tenant.current)
      end

      def table
        @table ||= Multitenanted::Table.find_by(name: params[:table_name])
      end
    end
  end
end
