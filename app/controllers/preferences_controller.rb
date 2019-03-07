class PreferencesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index]

  def index
    @user = current_user
  end

  def update
    mmmmhash = params.to_unsafe_h
    tag_arr = []
    mmmmhash.select { |k, v| v == "on" }.keys.each { |k| tag_arr << k }
    current_user.publication_list.add(tag_arr)
    current_user.save!

  def new
    @preferences = fetch_sources
  end

  private

  def fetch_sources
    url = "https://newsapi.org/v2/sources?language=en&apiKey=#{ENV['NEWSAPI_API_KEY']}"
    req = open(url)
    response_body = req.read
    preferences_json = JSON.parse(response_body)
    preferences = preferences_json["sources"]
    preferences.map! do |preference|
      preference["url"]#.match('/\/+(\S+)\//')
    end
    preferences.uniq
  end
end
