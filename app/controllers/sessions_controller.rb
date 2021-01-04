class SessionsController < ApplicationController
  def create
    client_id = '7d98c4f689e94a0131a5'
    client_secret = 'de33d917fcc8dd04f505da8afaca3bea7de94452'
    code = params[:code]

    conn = Faraday.new(url: 'https://github.com', headers: {'Accept': 'application/json'})

    response = conn.post('/login/oauth/access_token') do |req|
      req.params['code'] = code
      req.params['client_id'] = client_id
      req.params['client_secret'] = client_secret
    end

    data = JSON.parse(response.body, symbolize_names: true)
    access_token = data[:access_token]

    conn = Faraday.new(
      url: 'https://api.github.com',
      headers: {
        'Authorization': "token #{access_token}"
      }
    )
    response = conn.get('/user')
    data = JSON.parse(response.body, symbolize_names: true)

    user          = User.find_or_create_by(uid: data[:id])
    user.username = data[:login]
    user.uid      = data[:id]
    user.token    = access_token
    user.save

    session[:user_id] = user.id
    redirect_to dashboard_path

    response = Faraday.get("https://api.github.com/user/repos", {}, {"Authorization": "token #{user.token}" })
    data = JSON.parse(response.body, symbolize_names: true)
  end
end
