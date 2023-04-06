class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render status: :not_found
  end
end
