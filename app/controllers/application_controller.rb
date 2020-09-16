class ApplicationController < ActionController::Base
  # TODO: Add in API responses
  protected

  def parsed_json_input(json_input)
    JSON.parse json_input.gsub('=>', ': ').gsub("'", '"')
  end
end
