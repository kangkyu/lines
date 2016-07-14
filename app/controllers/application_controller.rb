class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :ensure_signed_out, only: [:new, :auth]
  before_action :ensure_signed_in, only: [:revoke]
  before_action :set_authenticated_account, only: [:auth]

  def new
  end

  def auth
    user = User.find_or_initialize_by email: @authenticated_account.email

    if user.save
      session[:user_id] = user.id
      session[:account] = basic_account_information
      redirect_to session.fetch :redirect_to, root_path
    else
      render_error user.errors.full_messages.to_sentence
    end
  end

  def revoke
    session[:user_id] = nil
    session[:account] = nil
    redirect_to root_path
  end

  def current_user
    User.find current_user_id
  end

  def signed_in?
    current_user_id.present?
  end

  def store_request_url
    session[:redirect_to] = request.url
  end

  helper_method :current_user
  helper_method :signed_in?
  helper_method :store_request_url

  def current_user_id
    session[:user_id]
  end

private

  def basic_account_information
    %i(email given_name avatar_url).map do |info|
      [info, @authenticated_account.public_send(info)]
    end.to_h
  end

  def ensure_signed_out
    redirect_to session[:redirect_to] ||= root_path if signed_in?
  end

  def ensure_signed_in
    unless signed_in?
      store_request_url
      redirect_to new_session_path
    end
  end
end
