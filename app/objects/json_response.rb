class JsonResponse
  class << self
    def fields_not_found(details = nil)
      { json:  {
        errors: [
          {
            status: '422',
            title: 'Unprocessable Entity',
            details: details.presence || 'Field(s) not found',
            code: '422'
          }
        ]
      }, status: :unprocessable_entity }
    end

    def forbidden(details = nil)
      { json: {
        errors: [
          {
            status: '403',
            title: 'Forbidden',
            details: details.presence || 'No permission to view this resource',
            code: '403'
          }
        ]
      }, status: :forbidden }
    end

    def not_found(details = nil)
      { json: {
        errors: [
          {
            status: '404',
            title: 'Not Found',
            details: details.presence || "Could not find record with ID",
            code: '404'
          }
        ]
      }, status: :not_found }
    end

    def validation_error(resource)
      { json: {
        errors: [
          {
            status: '422',
            title: 'Unprocessable Entity',
            detail: resource.errors,
            code: '422'
          }
        ]
      }, status: :unprocessable_entity }
    end
  end
end
