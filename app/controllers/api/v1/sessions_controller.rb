class Api::V1::SessionsController < Devise::SessionsController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  # below is not needed if protect_from_forgery is used
  #skip_before_filter :verify_authenticity_token

#CORS at the moment is realized in config.ru through rack-cors
#before_filter :cors_preflight_check
#after_filter :cors_set_access_control_headers
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

  respond_to :json

  skip_before_filter :authenticate_user!, :only => [:create, :new]
  skip_authorization_check only: [:create, :failure, :show_current_user, :options, :new]

  rescue_from Exception, with: :generic_exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  #{
  #"user": {
  #    "email":"user@example.com",
  #    "password":"changeme"
  #}
  #
  #}

  #def create
  #  warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
  #  render :status => 200, :json => { :success => true, :info => "Logged in", :user => current_user }
  #end

  #def destroy
  #  warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
  #  sign_out
  #  render :status => 200, :json => { :success => true, :info => "Logged out", :csrfParam => request_forgery_protection_token, :csrfToken => form_authenticity_token }
  #end

  def failure
    render :status => 401, :json => { :success => false, :info => "Login Credentials Failed" }
  end

  def show_current_user
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :status => 200, :json => { :success => true, :info => "Current User", :user => current_user }
  end

  private

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

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  def create

    respond_to do |format|
      format.html {
        super
      }
      format.json {

        resource = resource_from_credentials
        #build_resource
        return invalid_login_attempt unless resource

        if resource.valid_password?(params[:password])
          render :json => { user: { email: resource.email, :auth_token => resource.authentication_token } }, success: true, status: :created
        else
          invalid_login_attempt
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        user = User.find_by_authentication_token(request.headers['X-API-TOKEN'])
        if user
          user.reset_authentication_token!
          render :json => { :message => 'Session deleted.' }, :success => true, :status => 204
        else
          render :json => { :message => 'Invalid token.' }, :status => 404
        end
      }
    end
  end

  protected
  def invalid_login_attempt
    warden.custom_failure!
    render json: { success: false, message: 'Error with your login or password' }, status: 401
  end

  def resource_from_credentials
    data = { email: params[:email] }
    if res = resource_class.find_for_database_authentication(data)
      if res.valid_password?(params[:password])
        res
      end
    end
  end

end
