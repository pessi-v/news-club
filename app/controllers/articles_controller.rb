require 'open-uri'
require 'json'

class ArticlesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index]

  def index
    @articles = fetch_articles
    @plan1 = Plan.find(1)
    @plan2 = Plan.find(2)
  end

  def show
    @article = Article.find(params[:id])
    if current_user.subscription && (current_user.readings.length > current_user.subscription.plan.amount)
      @allow = false
    else
      @allow = true
      unless current_user.readings.find_by(article_id: @article.id) # don't create a new reading if user already has read this article
        @current_reading = Reading.new(user: current_user, article: @article)
        @current_reading.save!
        @snackbar = true
      end
    end
  end

  def home
    @all_user_articles = Article.tagged_with(current_user.publication_list, any: true)
    @user_read_articles = []
    current_user.readings.each do |reading|
      @user_read_articles << Article.find(reading.article_id)
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :author, :date, :source, :tag_list) ## Rails 4 strong params usage
  end

  def fetch_articles
    url = 'https://newsapi.org/v2/everything?'\
      'q=Climate&'\
      'sources=die-zeit,le-monde,liberation,the-guardian,new-scientist,le-monde,politico,the-economist,the-new-york-times,the-huffington-post,the-guardian-uk,the-jerusalem-post,financial-times,focus,la-repubblica,national-geographic,new-york-magazine,the-times-of-india' \
      'from=2019-03-05&'\
      'sortBy=publishedAt&'\
      "apiKey=#{ENV['NEWSAPI_API_KEY']}&"\
      "pageSize=20"

    req = open(url)
    response_body = req.read
    articles_json = JSON.parse(response_body)
    articles_array = articles_json["articles"]
    last_articles = []
    articles_array.each do |a|
      article = Article.find_by(title: a["title"])
      unless article # check if article is already in the database
        article = Article.new(title: a["title"], author: a["author"] || a["source"], source: a["source"]["name"], url: a["url"], date: a["publishedAt"], content: a["content"] || "no content available", image: a["urlToImage"], description: a["description"])
        article.publication_list.add(a["source"]["id"])
        extractor = Phrasie::Extractor.new
        tagging = extractor.phrases(a["content"], occur: 1)
        tags = tagging.each { |p| p[0] }
        article.publication_list.add(tags)
        article.save!
      end
      last_articles << article
    end
    last_articles
  end
end


