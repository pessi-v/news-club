require 'open-uri'
require 'json'

class ArticlesController < ApplicationController
  def index
    fetch_articles
  end

  private

  def user_params
    params.require(:article).permit(:title, :author, :date, :source, :tag_list) ## Rails 4 strong params usage
  end

  def fetch_articles
    url = 'https://newsapi.org/v2/everything?'\
      'q=Berlin&'\
      'from=2019-03-05&'\
      'sortBy=popularity&'\
      "apiKey=#{ENV['NEWSAPI_API_KEY']}"

    req = open(url)
    response_body = req.read
    articles_json = JSON.parse(response_body)
    articles_array = articles_json["articles"]
    last_articles = []
    articles_array.each do |a|
      if article = Article.find_by(url: a["url"]) #check if article is already in the database
        last_articles << article
      else article = Article.new(title: a["title"], author: a["author"], source: a["source"]["name"], url: a["url"], date: a["publishedAt"], content: a["content"], image: a["urlToImage"])
        last_articles << article
      end
    end
  end
end
