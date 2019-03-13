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
    # @all_user_articles = Article.all.shuffle
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
      'q=Climate OR forest OR mushroom OR flower OR animals OR anarchist OR peace OR ethereum OR rojava OR techno OR sanders OR corbyn OR beer OR whisky OR pluto OR mars OR future OR linux OR future OR berlin OR finland Or indonesia OR brazil&'\
      'from=2019-03-01&'\
      'sources=ars-technica,associated-press,bild,bloomberg,business-insider,business-insider,daily-mail,der-tagesspiegel,die-zeit,entertainment-weekly,espn,financial-post,financial-times,focus,fortune,gruenderszene,mirror,national-geographic,new-scientist,newsweek,new-york-magazine,politico,polygon,reuters,spiegel-online,techcrunch,techradar,the-economist,the-globe-and-mail,the-guardian-uk,the-hill,the-huffington-post,the-new-york-times,the-telegraph,the-verge,the-wall-street-journal,the-washington-times,time,wired'\
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
        article.theme_list.add(tags)
        article.save!
      end
      last_articles << article
    end
    last_articles
  end
end


