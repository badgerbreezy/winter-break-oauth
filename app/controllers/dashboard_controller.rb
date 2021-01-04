class DashboardController < ApplicationController
  def show
    response = Faraday.get("https://api.github.com/user/repos", {}, {"Authorization": "token #{current_user.token}" })
    @data = JSON.parse(response.body, symbolize_names: true)
  end
end
