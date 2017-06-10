class Api::V2Controller < ApiController
  rescue_from(Exceptions::InvalidDateRangeFormat) do |_e|
    render json: { error: 'Invalid Date Range Format' }, status: :bad_request
  end
end
