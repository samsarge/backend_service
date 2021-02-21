module Api
  module V1
    # Multitenanted records
    class RecordsController < ApplicationController
      skip_before_action :verify_authenticity_token # cause api, but should cors probably later

      # rescue_from ArgumentError,
                  # when we add rails params in
                  # RailsParam::Param::InvalidParameterError,
                  # with: :bad_request

      rescue_from ActiveRecord::RecordNotFound,
                  ActionController::RoutingError,
                  with: :not_found

      def index
        records = table.records
        # TODO: Add records serializer
        render json: records
      end

      def show
        record = table.records.find(params[:id])
        # TODO: Add records serializer
        render json: record
      end

      def create
        record = table.records.new(values: dynamic_record_params)
        if record.save
          # TODO: Add records serializer
          render json: record, status: :created
        else
          render json: record.errors, status: :unprocessable_entity
        end
      end

      def update
        record = table.records.find(params[:id])
        if record.update(values: dynamic_record_params)
          # TODO: Add records serializer
          render json: record, status: :ok
        else
          render json: record.errors, status: :unprocessable_entity
        end
      end

      def destroy
        record = table.records.find(params[:id])
        # Will add in a permissions system for users to manage what people can do
        # with all API endpoints and whether or not they need to be logged in / own the record
        return head(:no_content) if record.destroy
        
        render json: record.errors, status: :unprocessable_entity
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
