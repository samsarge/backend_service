module Api
  module V1
    # Multitenanted records
    class RecordsController < ApplicationController
      # cause api, security handled through cors
      skip_before_action :verify_authenticity_token

      rescue_from ActionController::ParameterMissing,
                  RailsParam::Param::InvalidParameterError,
                  ArgumentError,
                  with: :bad_request

      rescue_from ActiveRecord::RecordNotFound,
                  ActionController::RoutingError,
                  with: :not_found

      before_action :check_custom_bad_request, only: [:create, :update]
      before_action :validate_params_match_custom_datatypes, only: [:create, :update]

      def index
        records = table.records
        records = records.page(params[:page]) if params[:page].present?
        records = records.per(params[:per_page]) if params[:per_page].present?

        render json: records.map(&:as_hash_for_json)
      end

      def show
        record = table.records.find(params[:id])
        render json: record.as_hash_for_json
      end

      def create
        return bad_request if invalid_columns_present_in_params?

        record = table.records.new(values: dynamic_record_params)
        if record.save
          render json: record.as_hash_for_json, status: :created
        else
          render json: record.errors, status: :unprocessable_entity
        end
      end

      def update
        return bad_request if invalid_columns_present_in_params?

        record = table.records.find(params[:id])

        if record.update(values: dynamic_record_params)
          render json: record.as_hash_for_json, status: :ok
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

      def validate_params_match_custom_datatypes
        # from rails_params gem
        param!(model) do |m|
          table.structure['columns'].each do |col_hash|
            m.param!(col_hash['name'].to_sym, col_hash['datatype'].constantize, {})
          end
        end
      end

      def check_custom_bad_request
        # the model name should lead the values; { table_name_singular: { value1: value1 } }
        raise ArgumentError if params[model].nil? || invalid_columns_present_in_params?
      end

      def invalid_columns_present_in_params?
        (params[model].keys - dynamic_record_params.keys).any?
      end

      def dynamic_record_params
        column_names = table.structure['columns'].map { |col_hash| col_hash['name'] }
        params.require(model).permit(*column_names)
      end

      def model
        @model ||= table.name.singularize
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
