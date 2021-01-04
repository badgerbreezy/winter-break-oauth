class User < ApplicationRecord
  def self.repo_count
    response = Faraday.get("https://api.github.com/user/repos", {}, {"Authorization": "token #{current_user.token}" })
    @data = JSON.parse(response.body, symbolize_names: true)
    binding.pry
  end
end
