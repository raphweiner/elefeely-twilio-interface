class ApplicationController < ActionController::API

private

  def validate_request
    provenance = RequestProvenance.new(path: current_path, params: params)

    unauthorized unless provenance.authorized?
  end

  def current_path
    "#{request.protocol}#{request.host_with_port}#{request.path}"
  end

  def unauthorized
    render json: { 'error' => 'unauthorized' }, status: :unauthorized
  end
end

