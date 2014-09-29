class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authenticate_user!
    unless person_signed_in?
      redirect_to login_path, notice: ''
    end
    @person = current_person
  end


  def authenticate_api_user!
    if person_signed_in?
      @person = current_person
    else
      #TODO: use token to authenticate users through api
      redirect_to login_path
    end
  end
end
