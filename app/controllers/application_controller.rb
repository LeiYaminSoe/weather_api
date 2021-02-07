class ApplicationController < ActionController::API
  def not_found
    render json: { status: 404, message: 'Page Not Found' }
  end

  def unprocessable
    render json: { status: 422, message: 'Unprocessable Data' }
  end

  def internal_server_error
    render json: { status: 500, message: 'There is an Internal Server Error' }
  end
end
