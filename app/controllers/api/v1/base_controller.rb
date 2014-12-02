class Api::V1::BaseController < ActionController::Base


  protect_from_forgery with: :exception

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  #before_filter :cors_preflight_check
  #after_filter :cors_set_access_control_headers

  # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

  respond_to :json

  rescue_from Exception, with: :generic_exception
  #rescue_from :all, :backtrace => true
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  #error_formatter :json, API::ErrorFormatter

=begin
  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
  end
=end

  private

  def authenticate_user_from_token!
    user_email = request.headers["X-API-EMAIL"].presence
    user_auth_token = request.headers["X-API-TOKEN"].presence
    user = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, user_auth_token)
      sign_in(user, store: false)
    end
  end

  def record_not_found(error)
    respond_to do |format|
      format.json { render :json => {:error => error.message}, :status => 404 }
    end
  end

  def generic_exception(error)
    respond_to do |format|
      format.json { render :json => {:error => error.message}, :status => 500 }
    end
  end

end