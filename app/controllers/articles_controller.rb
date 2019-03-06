require 'open-uri'
require 'json'

class ArticlesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index]

  def index
    @articles = fetch_articles
  end

  def show
    @article = Article.find(params[:id])
  end

  private

  def article_params
    params.require(:article).permit(:title, :author, :date, :source, :tag_list) ## Rails 4 strong params usage
  end

  def fetch_articles
    url = 'https://newsapi.org/v2/everything?'\
      'q=Climate&'\
      'sources=die-zeit,le-monde,liberation,the-guardian,new-scientist,le-monde,politico,the-economist,the-new-york-times,the-huffington-post,the-guardian-uk,the-jerusalem-post,financial-times,focus,independent,la-repubblica,national-geographic,new-york-magazine,the-times-of-india' \
      'from=2019-03-05&'\
      'sortBy=publishedAt&'\
      "apiKey=#{ENV['NEWSAPI_API_KEY']}"

    req = open(url)
    response_body = req.read
    articles_json = JSON.parse(response_body)
    articles_array = articles_json["articles"]
    last_articles = []
    articles_array.each do |a|
      article = Article.find_by(title: a["title"])
      unless article # check if article is already in the database
        article = Article.new(title: a["title"], author: a["author"] || a["source"], source: a["source"]["name"], url: a["url"], date: a["publishedAt"], content: a["content"] || "no content available", image: a["urlToImage"], description: a["description"])
        article.save!
      end
      last_articles << article
    end
    last_articles
  end
end
