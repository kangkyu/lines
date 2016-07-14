module GoogleHelper
  def google_auth_url
    store_request_url if signed_in? && request.get?
    options = {scopes: google_auth_scopes}
    options[:redirect_uri] = store_google_redirect_uri
    @google_auth_url ||= Yt::Account.new(options).authentication_url
  end

private

  def store_google_redirect_uri
    session[:google_redirect_uri] = auth_sessions_url
  end

  def google_auth_scopes
    %w(userinfo.email userinfo.profile)
  end
end
