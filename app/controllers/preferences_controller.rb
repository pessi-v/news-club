class PreferencesController < ApplicationController

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
    #p preferences
    preferences.map! do |preference|
      preference["url"]#.match('/\/+(\S+)\//')
    end
    preferences.uniq
  end
end
