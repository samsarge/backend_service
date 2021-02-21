class ApplicationController < ActionController::Base
  # TODO: Add in API responses
  protected

  def parsed_json_input(json_input)
    JSON.parse json_input.gsub('=>', ': ').gsub("'", '"')
  end
end

# 200 success
# 201 created
# 300x redirect
# 404 not found
# 422 unprocessible entity - failed a validation
# 500 internal error
