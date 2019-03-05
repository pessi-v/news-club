require 'open-uri'
require 'json'

class ArticlesController < ApplicationController
  def index
    @articles = fetch_articles
  end

  private

  def article_params
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
      p a
      article = Article.find_by(url: a["url"])
      unless article # check if article is already in the database
        article = Article.new(title: a["title"], author: a["author"] || a["source"], source: a["source"]["name"], url: a["url"], date: a["publishedAt"], content: a["content"] || "no content available", image: a["urlToImage"], description: a["description"])
        article.save!
      end
      last_articles << article
    end
    last_articles
  end
end
