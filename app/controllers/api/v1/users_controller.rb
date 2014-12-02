class Api::V1::UsersController < Api::V1::BaseController
  #before_filter :authenticate_user!
  #after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show
    authorize current_user
    render :json => {:info => "Current User", :user => current_user}, :status => 200
  end

  def create
    @user = User.create(secure_params)

    authorize @user
    if @user.valid?
      sign_in(@user)
      respond_with @user, :location => api_users_path
    else
      respond_with @user.errors, :location => api_users_path
    end
  end

  def update
    @user = User.find(current_user.id)
    authorize @user

    respond_with :api, @user.update_attributes(secure_params)

=begin
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
=end
  end

  def destroy
    user = User.find(current_user.id)
    authorize user
    respond_with :api, user.destroy
  end

  private

  def secure_params
    params.require(:user).permit(:role, :email, :password, :password_confirmation)
  end

end
