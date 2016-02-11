class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      flash.notice = 'Logged in Failed. ' + @user.errors.full_messages.join('.')
      redirect_to new_user_registration_url
    end
  end

  alias_method :google_oauth2, :all

end