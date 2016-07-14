class SessionsController < ApplicationController
  def set_authenticated_account
    if params[:error]
      render_error "The sign-in process failed (#{params[:error].humanize})."
    elsif params[:code]
      begin
        @authenticated_account = google_authenticate_with params[:code]
      rescue Yt::Error => e
        render_error e.message.split("\n").first
      end
    else
      render_error 'The sign-in process failed (Missing authentication).'
    end
  end

  def google_authenticate_with(code)
    redirect_uri = session[:google_redirect_uri]
    options = {redirect_uri: redirect_uri, authorization_code: code}
    Yt::Account.new(options).tap{|account| account.access_token}
  end

  def render_error(message)
    render template: 'sessions/error', locals: {message: message}
  end

end
