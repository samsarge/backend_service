class ApplicationController < ActionController::Base
  protected

  def parsed_json_input(json_input)
    JSON.parse json_input.gsub('=>', ': ').gsub("'", '"')
  end

  # API stuff
  # 200 success
  # 201 created
  # 204 no content success - for deleting, a success when you dont return anythign back
  # 300x redirect
  # 400 bad request - sent the request wrong, wrong body etc
  # 404 not found
  # 422 unprocessible entity - record failed a validation
  # 500 internal error

  def bad_request(e)
    return head :bad_request unless e

    err_message = e.message
    err_message += " (#{e.param})" if e.respond_to?(:param)
    render json: { error: err_message }, status: :bad_request
  end

  def not_found
    head :not_found
  end
end
