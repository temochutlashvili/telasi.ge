# -*- encoding : utf-8 -*-
class Api::ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  after_filter :set_access_control_headers

  rescue_from Exception do |exception|
    render_api_error exception.message
  end

  protected

  def render_api_error(error)
    if error.is_a?(String)
      render json: { error: { message: error } }
    else
      errors = error.keys.map do |key|
        error[key].map { |msg|
          { error: { field: key, message: msg } }
        }
      end.flatten
      render json: { errors: errors }
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
  end
end
