class PreferencesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index]

  def index
    @user = current_user
    @sources = fetch_sources
    @images = Dir.glob("app/assets/images/cover-images/*.jpg")
    @authors = []
  end

  def update
    mmmmhash = params.to_unsafe_h
    tag_arr = []
    mmmmhash.select { |k, v| v == "on" }.keys.each { |k| tag_arr << k }
    current_user.publication_list.add(tag_arr)
    current_user.save!
    redirect_to home_path(id: current_user.id)
  end

  def new
    @sources = fetch_sources
  end

  # def image
  #   @images = Dir.glob("app/assets/images/cover-images/*.jpg")
  # end

  private

  def fetch_sources
    url = "https://newsapi.org/v2/sources?" \
          "language=en&" \
          "apiKey=#{ENV['NEWSAPI_API_KEY']}"

    req = open(url)
    response_body = req.read
    sources_json = JSON.parse(response_body)
    sources = sources_json["sources"]
    return sources
    # preferences.map! do |preference|
    #   preference["url"]#.match('/\/+(\S+)\//')
    # end
    # preferences.uniq
  end

end
